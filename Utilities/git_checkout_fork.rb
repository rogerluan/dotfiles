#!/usr/bin/env ruby

require 'json'
require 'open3'

# Function to execute a system command and return the output
def execute_command(command)
  stdout, stderr, status = Open3.capture3(command) # Use capture3 to get stdout, stderr
  unless status.success?
    error_message = "Command failed: #{command}\n"
    error_message += "STDOUT:\n#{stdout}\n" unless stdout.empty?
    error_message += "STDERR:\n#{stderr}\n" unless stderr.empty?
    raise error_message
  end
  stdout # Return stdout on success
end

def fetch_pr_details(url)
  match = url.match(%r{https://github.com/(?<org>[^/]+)/(?<repo>[^/]+)/pull/(?<pr_number>\d+)(/[^/]*)?/?$})
  return unless match

  org, repo, pr_number = match.values_at(:org, :repo, :pr_number)
  puts "Fetching PR details for #{org}/#{repo}##{pr_number}"
  command = "gh pr view #{pr_number} --json headRefName,headRepository,headRepositoryOwner --repo #{org}/#{repo}"
  puts command
  output = execute_command(command)

  details = JSON.parse(output)
  details.merge("pr_number" => pr_number)
rescue JSON::ParserError
  nil
end

def perform_git_operations(pr_details, pr_number)
  fork_org = pr_details['headRepositoryOwner']['login']
  fork_repo_name = pr_details['headRepository']['name']
  branch_name = pr_details['headRefName']

  # Define the name for the remote (e.g., "pr-123-fork") and its URL
  fork_remote_name = "pr-#{pr_number}-fork"
  fork_repo_url = "https://github.com/#{fork_org}/#{fork_repo_name}.git"

  # Remove the remote if it already exists to ensure the URL is up-to-date
  # and to prevent 'git remote add' from failing if run multiple times.
  # Errors are suppressed because the remote might not exist, which is fine.
  system("git remote remove #{fork_remote_name} > /dev/null 2>&1")

  # Add the fork's repository as a new remote
  puts "Adding remote '#{fork_remote_name}' for repository '#{fork_repo_url}'"
  execute_command("git remote add #{fork_remote_name} #{fork_repo_url}")

  # Fetch changes from the newly added remote
  puts "Fetching from remote '#{fork_remote_name}'"
  execute_command("git fetch #{fork_remote_name}")

  # Check if the local branch already exists
  # system() returns true if the command exits with 0 (success), false otherwise.
  # `git rev-parse --verify --quiet` will succeed if the branch exists.
  local_branch_exists = system("git rev-parse --verify --quiet #{branch_name}")

  if local_branch_exists
    puts "Branch '#{branch_name}' already exists locally. Checking it out."
    execute_command("git checkout #{branch_name}")
    # Optional: If the branch exists, you might want to ensure it's tracking the
    # correct remote branch and is up-to-date. For example:
    # execute_command("git branch --set-upstream-to=#{fork_remote_name}/#{branch_name} #{branch_name}")
    # execute_command("git pull --ff-only #{fork_remote_name} #{branch_name}")
    # Or, to force update to the fork's version:
    # execute_command("git reset --hard #{fork_remote_name}/#{branch_name}")
  else
    # If the branch doesn't exist locally, create it and set it to track the remote branch from the fork
    puts "Creating and checking out new local branch '#{branch_name}' from '#{fork_remote_name}/#{branch_name}'."
    execute_command("git checkout -b #{branch_name} #{fork_remote_name}/#{branch_name}")
  end

  # The original script had `git merge master` commented out; keeping it that way.
  # # `git merge master`
end

if ARGV.empty?
  puts "Usage: #{__FILE__} <pull request URL>"
  exit 1
end

pr_details = fetch_pr_details(ARGV[0])
if pr_details
  pr_number = pr_details["pr_number"]
  perform_git_operations(pr_details, pr_number)
  puts "✅ You're now in the branch for PR ##{pr_number}"
else
  puts "Failed to fetch PR details or invalid URL"
end
