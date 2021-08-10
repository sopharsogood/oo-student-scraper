require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = URI.open(index_url)
    doc_index = Nokogiri::HTML(html)
    doc_index.css(".student-card").each do |student|
      current_student_hash = {
        :name => student.css("h4").text,
        :location => student.css("p").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students << current_student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    current_student_hash = {}
    html = URI.open(profile_url)
    doc_profile = Nokogiri::HTML(html)
    current_student_hash[:bio] = doc_profile.css(".bio-block .description-holder").text.strip
    current_student_hash[:profile_quote] = doc_profile.css(".profile-quote").text
    doc_profile.css(".social-icon-container a").each do |social_link|
      link = social_link.attribute("href").value
      image = social_link.css("img").attribute("src").value
      case image
      when "../assets/img/twitter-icon.png"
        current_student_hash[:twitter] = link
      when "../assets/img/github-icon.png"
        current_student_hash[:github] = link
      when "../assets/img/linkedin-icon.png"
        current_student_hash[:linkedin] = link
      when "../assets/img/rss-icon.png"
        current_student_hash[:blog] = link
      end
    end
    current_student_hash
  end

end

