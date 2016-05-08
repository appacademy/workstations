#!/usr/bin/env ruby

def make_github_url(user, repo, remainder)
  "https://github.com/#{user}/#{repo}#{remainder}"
end

GITHUB_REGEX = Regexp.new make_github_url("([^/]+)", "([^/]+)", "(.*)")
AA_USER = 'appacademy'

def aa_github_url?(url)
  mdata = GITHUB_REGEX.match(url)
  return nil unless mdata

  user = mdata[1]
  user == AA_USER
end

def corresponding_aa_github_url(url, repo)
  mdata = GITHUB_REGEX.match(url)
  return nil unless mdata

  url_repo = mdata[2]
  remainder = mdata[3]

  return make_github_url(AA_USER, repo, remainder) if url_repo == repo
  nil
end

puts corresponding_aa_github_url ARGV[0], ARGV[1]
