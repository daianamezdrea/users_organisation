#!/usr/bin/env ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'erb'

# uri = URI('https://onebox.demo.aserto.com/api/v1/dir/users?page.size=10&page.token=')
# response = Net::HTTP.get_response(uri)
# if response.is_a?(Net::HTTPSuccess)
#   output = response.body.gsub(/\n/, '')
#   parsed = JSON.parse(output)
# end
def call_api(next_token)
  uri = URI("https://onebox.demo.aserto.com/api/v1/dir/users?page.size=10&page.token=#{next_token}")
  response = Net::HTTP.get_response(uri)
  if response.is_a?(Net::HTTPSuccess)
    output = response.body.gsub(/\n/, '')
    parsed = JSON.parse(output)
  end
  return parsed
end

departments = []
department_info = {}
users_info = []

def collect_data(parsed, users_info)
  parsed['results'].each do |result|
    users_info << {
      'enabled': result['enabled'],
      'id_user': result['id'],
      'name_user': result['display_name'],
      'email_user': result['email'],
      'department': result['attributes']['properties']['department'],
      'title': result['attributes']['properties']['title'],
      'photo': result['picture'],
      'manager_id': result['attributes']['properties']['manager'],     
    }
  end
end

def get_next(users_info)
  parsed = call_api('')
  next_token = parsed['page']['next_token']
  collect_data(parsed, users_info)
  while next_token != ''
   parsed = call_api(next_token)
    collect_data(parsed, users_info)
    next_token = parsed['page']['next_token']
  end
end

get_next(users_info)

department_info = users_info.group_by { |x| x[:department] }

def find_users(id, users_info)
  users_info.each do |user|
    if user[:id_user] == id 
      return user
    end
  end
  return nil
end

html_users = ERB.new(File.read('templates/users_page.html.erb')).result(binding)
File.open('html/users_page.html', 'wb') do |f|
  f.puts(html_users)
end

html_department = ERB.new(File.read('templates/department.html.erb')).result(binding)
File.open('html/department.html', 'wb') do |f|
  f.puts(html_department)
end

html_org_chart = ERB.new(File.read('templates/org_chart.html.erb')).result(binding)
File.open('html/org_chart.html', 'wb') do |f|
  f.puts(html_org_chart)
end

