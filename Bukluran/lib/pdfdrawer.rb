require "pdf/simpletable"
class PdfDrawer
  def self.draw(org)
   
    pdf = PDF::Writer.new(:paper => "A4")
    pdf.text "<c:uline>Osa Form 1</c:uline>", :font_size => 10
    pdf.text "<c:uline><b>INFORMATION SHEET FOR STUDENT ORGANIZATIONS</b></c:uline>", :justification => :center, :font_size => 15, :spacing => 2
    pdf.text "<b>Official Name of Organization:</b> #{org.name}", :font_size => 12, :spacing => 2
	pdf.text "<b>Acronym or other names:</b> #{org.acronym}"
	pdf.text "<b>Date Established:</b> #{org.date_established}"
	pdf.text "<b>Nature of Organization</b> #{org.nature}"
	pdf.text "<b>Category:</b> #{org.category}"
	pdf.text "<b>Mailing Address:</b> #{org.mailing_address}"
	pdf.text "<b>Permanent E-mail Address of the Organization:</b> #{org.email_org}"
	pdf.text "<b>E-mail Address of the Head of the Organization:</b> #{org.email_head}"
	pdf.text " ", :spacing => 2
	
	table = PDF::SimpleTable.new
    table.title = "<b>Membership Distribution</b>"
    table.column_order.push(*%w(1 2 3 4 5 6 7 8))

    table.columns["1"] = PDF::SimpleTable::Column.new("1")
    table.columns["1"].heading = ""

    table.columns["2"] = PDF::SimpleTable::Column.new("2")
    table.columns["2"].heading = "Sophomores"
    
    table.columns["3"] = PDF::SimpleTable::Column.new("2")
    table.columns["3"].heading = "Juniors"
    
    table.columns["4"] = PDF::SimpleTable::Column.new("2")
    table.columns["4"].heading = "Seniors"
    
    table.columns["5"] = PDF::SimpleTable::Column.new("2")
    table.columns["5"].heading = "Post Grad Courses"
    
    table.columns["6"] = PDF::SimpleTable::Column.new("2")
    table.columns["6"].heading = "MA/MS"
    
    table.columns["7"] = PDF::SimpleTable::Column.new("2")
    table.columns["7"].heading = "PhD"
    
    table.columns["8"] = PDF::SimpleTable::Column.new("2")
    table.columns["8"].heading = "Total"

    table.show_lines    = :all
    table.show_headings = true
    table.orientation   = :center
    table.position      = :center
    
    @mt = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'm', org.id]).size
    @ft = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'f', org.id]).size
    @msop = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'm', org.id, (Time.now.year)*100000, (Time.now.year-2)*100000]).size
    @fsop = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'f', org.id, (Time.now.year)*100000, (Time.now.year-2)*100000]).size
    @mjun = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'm', org.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000]).size
    @fjun = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ?', 'f', org.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000]).size
    @msen = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'm', org.id, (Time.now.year-3)*100000]).size
    @fsen = Membership.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'f', org.id, (Time.now.year-3)*100000]).size
    @mphd = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'm', org.id]).size
    @mmas = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'MAS', 'm', org.id]).size
    @fphd = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'f', org.id]).size
    @fmas = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'MAS', 'f', org.id]).size
    @mpgc = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'm', org.id]).size
    @fpgc = Membership.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'f', org.id]).size
    data = [
	 {"1"=> "Male", "2"=> @msop, "3"=> @mjun,"4"=> @msen,"5"=> @mpgc,"6"=> @mmas,"7"=> @mphd, "8" => @mt},
	 {"1"=> "Female", "2"=> @fsop, "3"=> @fjun,"4"=> @fsen,"5"=> @fpgc,"6"=> @fmas,"7"=> @fphd, "8" => @ft},
	 {"1"=> "Total", "2"=> @msop+@fsop, "3"=> @mjun+@fjun,"4"=> @msen+@fsen,"5"=> @mpgc+@fpgc,"6"=> @mmas+@fmas,"7"=> @mphd+@fphd, "8" => @mt+@ft},
    ]

    table.data.replace data
    table.render_on(pdf)
    
    pdf.start_new_page
    pdf.text "<c:uline>Osa Form 6: Calendar of Activities</c:uline>", :font_size => 10
    
    @events = org.events
    for c in ["Academic Activities", "Advocacy and Extension Service", "UP Community Service", "Organization - Capacity Building Activities"]
		if @events.find_by_category(c)
			pdf.text "<b>#{c}</b>"
			for event in @events.all(:conditions => "category = '#{c}'")
				pdf.text "#{event.name}", :spacing => 2
				pdf.text "Date: #{event.date}"
				pdf.text "Venue: #{event.venue}"
				pdf.text "Description: #{event.description}"
				pdf.text "Person in-Charge: #{event.event_head}"
		  end
		end
	end
    pdf.render
    
    
  end
end