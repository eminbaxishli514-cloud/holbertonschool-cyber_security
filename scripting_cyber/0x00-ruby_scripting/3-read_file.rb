#!/usr/bin/env ruby
require 'json'

def count_user_ids(path)
    file_content = File.read(path)
    data = JSON.parse(file_content)

    counts = Hash.new(0)
    data.each do |item|
        user_id = item["userId"]
        counts[user_id] += 1 if user_id
    end

    counts.sort.each do |user_id, count|
        puts "#{user_id}: #{count}"
    end
end
