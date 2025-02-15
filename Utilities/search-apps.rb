require 'net/http'
require 'json'
require 'uri'

def search_app_details(bundle_id)
  if bundle_id.nil? || bundle_id.strip.empty?
    puts "⚠️ No bundle identifier provided. Usage: ruby script.rb '<bundle_id>'"
    return
  end

  puts "Searching for details for Bundle ID: #{bundle_id}...\n\n"

  # Search App Store
  search_app_store(bundle_id)

  # Search Google Play
  search_google_play(bundle_id)
end

def search_app_store(bundle_id)
  puts "🔍 Searching the App Store..."
  url = URI("https://itunes.apple.com/lookup?bundleId=#{bundle_id}")
  response = Net::HTTP.get(url)


  begin
    json_response = JSON.parse(response)
    result_count = json_response['resultCount'].to_i

    if result_count == 0
      puts "❌ No results found on the App Store for Bundle ID: #{bundle_id}\n\n"
    else
      app_data = json_response['results'].first
      app_name = app_data['trackName']

      puts "✅ App Store Info:"
      puts "  App Name: #{app_name}"
      puts "  Developer: #{app_data['sellerName']}"
      puts "  App Store URL: #{app_data['trackViewUrl']}\n\n"
    end
  rescue JSON::ParserError => e
    puts "⚠️ Failed to parse App Store response: #{e.message}\n\n"
  end
end

def search_google_play(bundle_id)
  puts "🔍 Searching Google Play..."
  url = URI("https://play.google.com/store/apps/details?id=#{bundle_id}")
  response = Net::HTTP.get_response(url)

  if response.is_a?(Net::HTTPSuccess)
    puts "✅ Google Play Info:"
    puts "  Google Play URL: #{url}\n\n"
  else
    puts "❌ No results found on Google Play for Bundle ID: #{bundle_id}\n\n"
  end
end

# Main script execution
if __FILE__ == $0
  bundle_id = ARGV[0]
  search_app_details(bundle_id)
end
