require 'bundler'
Bundler.require
OpenURI::Cache.cache_path = 'archive'

sections = %w(flowers-checklist fruit-veg-checklist greenhouse-checklist around-garden-checklist)
1.upto(52) do |week_number|
  sections.each do |section|
    url = "http://www.gardenersworld.com/what-to-do-now/week#{week_number}/#{section}/?print=true"
    warn "Fetching: #{url}"
    page = Nokogiri::HTML(open(url))
    page.css('.checklist ul:first li').each do |job|
      data = {
        week: week_number,
        section: section,
        job: job.text
      }
      ScraperWiki.save_sqlite([:week, :section, :job], data)
    end
  end
end
