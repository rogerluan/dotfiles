#!/usr/bin/env ruby

require 'json'
require 'open3'

# Function to execute a system command and return the output
def execute_command(command)
  output, status = Open3.capture2(command)
  raise "Command failed: #{command}" unless status.success?
  output
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
  fork_repo = pr_details['headRepository']['name']
  branch_name = pr_details['headRefName']

  `git fetch pr-#{pr_number}-fork`

  # Check if the branch already exists
  branch_exists = system("git rev-parse --verify #{branch_name}")
  # Only create the branch if it doesn't exist
  unless branch_exists
    `git checkout -b #{branch_name} pr-#{pr_number}-fork/#{branch_name}`
  else
    `git checkout #{branch_name}`
  end
  # `git merge master`
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
