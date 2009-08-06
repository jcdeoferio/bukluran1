require "pdf/simpletable"
class PdfDrawer
  def self.draw(org, filepath, bool)
    pdf = PDF::Writer.new(:paper => "A4")
    #form1------------------
    pdf.text "<c:uline>Osa Form 1</c:uline>", :font_size => 10
    
    pdf.text "<c:uline><b>INFORMATION SHEET FOR STUDENT ORGANIZATIONS</b></c:uline>", :justification => :center, :font_size => 15, :spacing => 2
    pdf.text "Official Name of Organization:</b> <c:uline>#{org.name}</c:uline>", :font_size => 11, :spacing => 2
	pdf.text "Acronym or other names: <c:uline>#{org.acronym}</c:uline>", :spacing => 1.5
	pdf.text "Date Established: <c:uline>#{org.date_established}</c:uline>", :spacing => 1.5
	pdf.text "Nature of Organization: <c:uline>#{org.nature}</c:uline>", :spacing => 1.5
	pdf.text "Category: <c:uline>#{org.category}</c:uline>", :spacing => 1.5
	pdf.text "Mailing Address: <c:uline>#{org.mailing_address}</c:uline>", :spacing => 1.5
	pdf.text "Permanent E-mail Address of the Organization: <c:uline>#{org.email_org}</c:uline>", :spacing => 1.5
	pdf.text "E-mail Address of the Head of the Organization: <c:uline>#{org.email_head}</c:uline>", :spacing => 1.5
	@sec = "No"
	if org.sec_incorporated
      @sec = "Yes, Date: #{org.date_incorporation}"
	end
	pdf.text "Incorporated with the Securities & Exchange Commission: #{@sec}", :spacing => 1.5
	pdf.text " ", :spacing => 2
	
	table = PDF::SimpleTable.new
    table.title = "<b>Membership Distribution</b>"
    table.column_order.push(*%w(1 2 3 4 5 6 7 8))

    table.columns["1"] = PDF::SimpleTable::Column.new("1")
    table.columns["1"].heading = ""

    table.columns["2"] = PDF::SimpleTable::Column.new("2")
    table.columns["2"].heading = "Sophomores"
    
    table.columns["3"] = PDF::SimpleTable::Column.new("3")
    table.columns["3"].heading = "Juniors"
    
    table.columns["4"] = PDF::SimpleTable::Column.new("4")
    table.columns["4"].heading = "Seniors"
    
    table.columns["5"] = PDF::SimpleTable::Column.new("5")
    table.columns["5"].heading = "Post Grad Courses"
    
    table.columns["6"] = PDF::SimpleTable::Column.new("6")
    table.columns["6"].heading = "MA/MS"
    
    table.columns["7"] = PDF::SimpleTable::Column.new("7")
    table.columns["7"].heading = "PhD"
    
    table.columns["8"] = PDF::SimpleTable::Column.new("8")
    table.columns["8"].heading = "Total"

    table.show_lines    = :all
    table.show_headings = true
    table.orientation   = :center
    table.position      = :center
    
    #kapag papalitan ang db baka palitan natin yung conditions. flag lang. natagalan ako dahil sa errors ng SQL T_T
    @mt = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'm', org.id]).size
    @ft = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ?', 'f', org.id]).size
    @msop = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'm', org.id, (Time.now.year)*100000, (Time.now.year-2)*100000, 'BS', 'BA']).size
    @fsop = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'f', org.id, (Time.now.year)*100000, (Time.now.year-2)*100000, 'BS', 'BA']).size
    @mjun = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'm', org.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000, 'BS', 'BA']).size
    @fjun = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ? AND student_no > ? AND (degree_program = ? OR degree_program = ?)', 'f', org.id, (Time.now.year-2)*100000, (Time.now.year-3)*100000, 'BS', 'BA']).size
    @msen = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'm', org.id, (Time.now.year-3)*100000]).size
    @fsen = Member.all(:joins => :student, :conditions => ['gender = ? AND organization_id = ? AND student_no < ?', 'f', org.id, (Time.now.year-3)*100000]).size
    @mphd = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'm', org.id]).size
    @mmas = Member.all(:joins => :student, :conditions => ['(degree_program = ? OR degree_program = ?) AND gender = ? AND organization_id = ?', 'MS', 'MA', 'm', org.id]).size
    @fphd = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PHD', 'f', org.id]).size
    @fmas = Member.all(:joins => :student, :conditions => ['(degree_program = ? OR degree_program = ?) AND gender = ? AND organization_id = ?', 'MS', 'MA', 'f', org.id]).size
    @mpgc = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'm', org.id]).size
    @fpgc = Member.all(:joins => :student, :conditions => ['degree_program = ? AND gender = ? AND organization_id = ?', 'PGC', 'f', org.id]).size
    data = [
	 {"1"=> "Male", "2"=> @msop, "3"=> @mjun,"4"=> @msen,"5"=> @mpgc,"6"=> @mmas,"7"=> @mphd, "8" => @mt},
	 {"1"=> "Female", "2"=> @fsop, "3"=> @fjun,"4"=> @fsen,"5"=> @fpgc,"6"=> @fmas,"7"=> @fphd, "8" => @ft},
	 {"1"=> "Total", "2"=> @msop+@fsop, "3"=> @mjun+@fjun,"4"=> @msen+@fsen,"5"=> @mpgc+@fpgc,"6"=> @mmas+@fmas,"7"=> @mphd+@fphd, "8" => @mt+@ft},
    ]

    table.data.replace data
    table.render_on(pdf)
    
    pdf.text " ", :spacing => 2
	
	table = PDF::SimpleTable.new
    table.title = "<b>Faculty Adviser and Co-Adviser/s</b>"
    table.column_order.push(*%w(1 2 3 4 5))
    
    table.columns["1"] = PDF::SimpleTable::Column.new("1")
    table.columns["1"].heading = ""

    table.columns["2"] = PDF::SimpleTable::Column.new("2")
    table.columns["2"].heading = "Name"
    
    table.columns["3"] = PDF::SimpleTable::Column.new("3")
    table.columns["3"].heading = "Department/College"
    
    table.columns["4"] = PDF::SimpleTable::Column.new("4")
    table.columns["4"].heading = "Designated Faculty \nPosition and Rank"
    
    table.columns["5"] = PDF::SimpleTable::Column.new("5")
    table.columns["5"].heading = "Contact Number"
    
    table.show_lines    = :all
    table.show_headings = true
    table.orientation   = :center
    table.position      = :center
    
    data = [
	 {"1"=> "Adviser", "2"=> org.adviser1_name, "3"=> org.adviser1_dept,"4"=> org.adviser1_position,"5"=> "Home: #{org.adviser1_home} \nOffice: #{org.adviser1_office} \nEmail: #{org.adviser1_email}" },
	 {"1"=> "Co-adviser", "2"=> org.adviser2_name, "3"=> org.adviser2_dept,"4"=> org.adviser2_position,"5"=> "Home: #{org.adviser2_home} \nOffice: #{org.adviser2_office} \nEmail: #{org.adviser2_email}" },
	 {"1"=> "Co-adviser", "2"=> org.adviser3_name, "3"=> org.adviser3_dept,"4"=> org.adviser3_position,"5"=> "Home: #{org.adviser3_home} \nOffice: #{org.adviser3_office} \nEmail: #{org.adviser3_email}" },
    ]

    table.data.replace data
    table.render_on(pdf)
    pdf.text "Brief Description: <c:uline>#{org.description}</c:uline>", :spacing => 2
    
    @year = Time.now.year
    @schoolyear = ""
	if Time.now.month >4 && Time.now.month <11
	 @schoolyear = "#{@year.to_s} - #{(@year+1).to_s}"
	 @sem = "1st Semester"
	else
	 @schoolyear = "#{(@year-1).to_s} - #{@year.to_s}"
	 @sem = "2nd Semester"
	end
    
    #form3-----------------
    pdf.start_new_page
    pdf.text "<b>Osa Form 3: Roster of all Officers</b>", :font_size => 10
    pdf.text "Name of Organization:<c:uline>#{org.name}</c:uline>", :spacing => 2
    pdf.text "Category of Organization:<c:uline>#{org.category}</c:uline>   School Year:<c:uline>#{@schoolyear}</c:uline>"
    @officers = Member.all(:conditions => "position != 'MEMBER' AND organization_id == #{org.id}")
    for o in @officers
      @student = o.student
      pdf.text "Full Name: <c:uline>#{@student.name}</c:uline> Nickname: <c:uline>#{@student.nickname}</c:uline>", :spacing => 2
      pdf.text "Student No: <c:uline>#{@student.student_no}</c:uline>"
      pdf.text "Contact No: <c:uline>#{@student.contact_no}</c:uline>"
      pdf.text "College: <c:uline>#{@student.college}</c:uline> Course:<c:uline>#{@student.course}</c:uline>"
      pdf.text "Position: <c:uline>#{o.position}</c:uline><c:uline>#{@student.title}</c:uline>"
      pdf.text "Permanent Home Address: <c:uline>#{@student.permanent_address}</c:uline>"
      pdf.text "Present Home Address: <c:uline>#{@student.present_address}</c:uline>"
      pdf.text "Name of Parent or Guardian: <c:uline>#{@student.guardian}</c:uline> Tel. No: <c:uline>#{@student.guardian_telno}</c:uline>"
      pdf.text "Address of Parent/Guardian: <c:uline>#{@student.guardian_address}</c:uline>"
    end
    
    #form4-----------------
    pdf.start_new_page
    pdf.text "<b>Osa Form 4: Roster of all Members</b>", :font_size => 10
    pdf.text "Name of Organization:<c:uline>#{org.name}</c:uline>", :spacing => 2
    pdf.text "Category of Organization:<c:uline>#{org.category}</c:uline>   School Year:<c:uline>#{@schoolyear}</c:uline>"
    @members = Member.all(:conditions => "position = 'MEMBER' AND organization_id == #{org.id}")
    for o in @members
      @student = o.student
      pdf.text "Full Name: <c:uline>#{@student.name}</c:uline> Nickname: <c:uline>#{@student.nickname}</c:uline>", :spacing => 2
      pdf.text "Student No: <c:uline>#{@student.student_no}</c:uline>"
      pdf.text "Contact No: <c:uline>#{@student.contact_no}</c:uline>"
      pdf.text "College: <c:uline>#{@student.college}</c:uline> Course:<c:uline>#{@student.course}</c:uline>"
      pdf.text "Permanent Home Address: <c:uline>#{@student.permanent_address}</c:uline>"
      pdf.text "Present Home Address: <c:uline>#{@student.present_address}</c:uline>"
      pdf.text "Name of Parent or Guardian: <c:uline>#{@student.guardian}</c:uline> Tel. No: <c:uline>#{@student.guardian_telno}</c:uline>"
      pdf.text "Address of Parent/Guardian: <c:uline>#{@student.guardian_address}</c:uline>"
    end
    
    #form6-----------------
    pdf.start_new_page
    pdf.text "<c:uline>Osa Form 6: Calendar of Activities</c:uline>", :font_size => 10
    pdf.text "Name of Organization:<c:uline>#{org.name}</c:uline>", :spacing => 2
    pdf.text "Category of Organization:<c:uline>#{org.category}</c:uline>   School Year:<c:uline>#{@schoolyear}</c:uline>"
   
    @events = org.events
    for c in ["Academic Activities", "Advocacy and Extension Service", "UP Community Service", "Organization - Capacity Building Activities"]
		if @events.find_by_category(c)
		  pdf.text " ", :spacing => 1
		  table = PDF::SimpleTable.new
          table.title = "<b>#{c}</b>"
          table.column_order.push(*%w(1 2 3 4))
    
          table.columns["1"] = PDF::SimpleTable::Column.new("1")
          table.columns["1"].heading = "Title of Activity"

          table.columns["2"] = PDF::SimpleTable::Column.new("2")
          table.columns["2"].heading = "Brief Description of Activity"
    
          table.columns["3"] = PDF::SimpleTable::Column.new("3")
          table.columns["3"].heading = "Venue/Date"
    
          table.columns["4"] = PDF::SimpleTable::Column.new("4")
          table.columns["4"].heading = "Person \nin Charge"
    
          table.show_lines    = :all
          table.show_headings = true
          table.orientation   = :center
          table.position      = :center
    
          data = []
          for event in @events.all(:conditions => "category = '#{c}'")
		    data.concat([{"1" => "#{event.name}", "2" => "#{event.description}", "3" => "#{event.venue}/#{event.date}", "4" => "#{event.head}" }])
		  end
		  
          table.data.replace data
          table.render_on(pdf)
		end
	end
	
	#form7------------
    pdf.start_new_page
    pdf.text "<c:uline>Osa Form 7: Acknowledgement</c:uline>", :font_size => 10
	
	@files = []
	@path = "/data/#{filepath}/Form_7"
	Find.find("public#{@path}") do |path|
		if FileTest.directory?(path)
		  next
		else
		  fname = File.basename(path)
		  @files << fname.camelize.to_s #get all files
		end
	end
	
	for filename in @files
      pdf.image "public/data/#{filepath}/Form_7/#{filename}"
    end
    
    #---save
    if bool
      pdf.save_as("public/data/#{filepath}/#{org.acronym}Application.pdf")
    end
	#---render
    pdf.render
  end
end