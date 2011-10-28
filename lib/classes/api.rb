module Artesia
  class API
    SEARCH_ATTR = {
      :keyword        => "searchTerm",
      :scope          => "searchScope",
      :sort_field     => "Sort0_field",
      :sort_order     => "Sort0_order",
      :model          => "modelSelector",
      :boolean        => "booleanOperator",
      :asset_name     => "Asset Name_1018",
      :asset_id       => "Asset ID_1445",
      :keywords       => "Keywords_1373",
      :copyright      => "Copyright Notice_1059",
      :deleted        => "Content Status_1486",
      :locked         => "Content Status_1486",
      :normal         => "Content Status_1486"
    }
    
    attr_accessor :connection
  
    def initialize(connection)
      instance_variable_set "@connection", connection
    end
    
    def advsearch(attributes = {})
      attributes = set_attribute_keys(attributes, SEARCH_ATTR)
      attributes[:viewType] = "spreadsheet view"
      attributes[:form] = "QueryForm"
      attributes[:model] = "-99"
      attributes[:cmd] = "general"
      attributes[:Sort0_field] = "1018" if attributes[:Sort0_field].nil?
      attributes[:Sort0_order] = "Descending" if attributes[:Descending].nil?
      attributes[:modelSelector] = "100000" if attributes[:modelSelector].nil?
      attributes[:booleanOperator] = "AND" if attributes[:booleanOperator].nil?
puts attributes
      parse_advsearch(post("LLDSAdvSearch.do?action=9", attributes))
    end
    
    private
    
    def set_attribute_keys(attributes = {}, replace_attributes = {})
      Hash[attributes.map{|key,value| [replace_attributes[key], value]}]
    end
    
    def post(url, params = {})
      Mechanize.new.post(connection.host+url, params, {"Cookie" => "user=#{connection.username}; JSESSIONID=#{connection.session}"})
    end
    
    def login
      page = Mechanize.new.post(connection.host+"Login.do", {"action" => "2","UserName" => connection.username, "Passwd" => connection.password})
      connection.session = page.header["set-cookie"]
    end
    
    def parse_advsearch(page)
      login if page.title.to_s.eql?("Artesia Login")
      
      error = page.search("//td[@class='error'][@valign='middle']").first
      error_message = error.search("span[@id='errorMessage']").first unless error.nil?
      feedback = page.search("//td[@class='feedback'][@valign='middle']").first
      info_message = feedback.search("span[@id='infoMessage']").first unless feedback.nil?

      if error_message.nil? or info_message.nil?
        return [] #error_message.nil? ? error : feedback
      else
        #num_results = page.search("//td[@class='pagingText']").inner_html.match(/(\d+)/)[0]

        headings = []
        heading_tags = page.search("//td[@class='tableHeaderBackground']/span/text()")
        heading_tags[1,6].each{|heading| headings << heading.content }

        these_rows = []
        rows = page.search("//tr[starts-with(@class, 'Row')]")

        rows.each{|row|
          this_row = {}
          columns = row.search("td")[3,6]
          columns.each_with_index{|column, index|
            cell = column.inner_html.gsub(/<[^>]+>/, '').strip
            this_row[headings[index].to_sym] = cell
          }
          these_rows << this_row
        }

        return these_rows
      end
    end
  end
end