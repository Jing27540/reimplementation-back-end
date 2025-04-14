begin
    #Create an instritution
    inst_id = Institution.create!(
      name: 'North Carolina State University',
    ).id
    
    # Create an admin user
    User.create!(
      name: 'admin',
      email: 'admin2@example.com',
      password: 'password123',
      full_name: 'admin admin',
      institution_id: 1,
      role_id: 1
    )
    

    #Generate Random Users
    num_students = 48
    num_assignments = 8
    num_teams = 16
    num_courses = 2
    num_instructors = 2
    
    puts "creating instructors"
    instructor_user_ids = []
    num_instructors.times do
      instructor_user_ids << User.create(
        name: Faker::Internet.unique.username,
        email: Faker::Internet.unique.email,
        password: "password",
        full_name: Faker::Name.name,
        institution_id: 1,
        role_id: 3,
      ).id
    end

    puts "creating courses"
    course_ids = []
    num_courses.times do |i|
      course_ids << Course.create(
        instructor_id: instructor_user_ids[i],
        institution_id: inst_id,
        directory_path: Faker::File.dir(segment_count: 2),
        name: Faker::Company.industry,
        info: "A fake class",
        private: false
      ).id
    end

    puts "creating assignments"
    assignment_ids = []
    num_assignments.times do |i|
      assignment_ids << Assignment.create(
        name: Faker::Verb.base,
        instructor_id: instructor_user_ids[i%num_instructors],
        course_id: course_ids[i%num_courses],
        has_teams: true,
        private: false
      ).id
    end


    puts "creating teams"
    team_ids = []
    num_teams.times do |i|
      team_ids << Team.create(
        assignment_id: assignment_ids[i%num_assignments]
      ).id
    end

    puts "creating students"
    student_user_ids = []
    num_students.times do
      student_user_ids << User.create(
        name: Faker::Internet.unique.username,
        email: Faker::Internet.unique.email,
        password: "password",
        full_name: Faker::Name.name,
        institution_id: 1,
        role_id: 5,
      ).id
    end

    puts "assigning students to teams"
    teams_users_ids = []
    #num_students.times do |i|
    #  teams_users_ids << TeamsUser.create(
    #    team_id: team_ids[i%num_teams],
    #    user_id: student_user_ids[i]
    #  ).id
    #end

    num_students.times do |i|
      puts "Creating TeamsUser with team_id: #{team_ids[i % num_teams]}, user_id: #{student_user_ids[i]}"
      teams_user = TeamsUser.create(
        team_id: team_ids[i % num_teams],
        user_id: student_user_ids[i]
      )
      if teams_user.persisted?
        teams_users_ids << teams_user.id
        puts "Created TeamsUser with ID: #{teams_user.id}"
      else
        puts "Failed to create TeamsUser: #{teams_user.errors.full_messages.join(', ')}"
      end
    end

    puts "assigning participant to students, teams, courses, and assignments"
    participant_ids = []
    num_students.times do |i|
      participant_ids << Participant.create(
        user_id: student_user_ids[i],
        assignment_id: assignment_ids[i%num_assignments],
        team_id: team_ids[i%num_teams],
      ).id
    end



  # ------------------------------------------  
    # # Creating some example students
    # students = Student.create([
    #   { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com' },
    #   { first_name: 'Jane', last_name: 'Smith', email: 'jane.smith@example.com' },
    #   { first_name: 'Alex', last_name: 'Johnson', email: 'alex.johnson@example.com' }
    # ])

    # # Creating some example tasks
    # tasks = Task.create([
    #   { name: 'Math Homework', description: 'Solve equations and problems', due_date: '2025-05-01' },
    #   { name: 'Science Project', description: 'Complete the project on biology', due_date: '2025-06-01' },
    #   { name: 'History Essay', description: 'Write an essay on ancient civilizations', due_date: '2025-04-15' }
    # ])

    # # Associating students with tasks (creating StudentTask entries)
    # StudentTask.create([
    #   { student: students[0], task: tasks[0], status: 'completed', submission_date: '2025-04-10' },
    #   { student: students[0], task: tasks[1], status: 'pending' },
    #   { student: students[1], task: tasks[2], status: 'completed', submission_date: '2025-04-12' },
    #   { student: students[2], task: tasks[1], status: 'in_progress' },
    #   { student: students[2], task: tasks[0], status: 'completed', submission_date: '2025-04-08' }
    # ])

    # puts 'Seed data for students, tasks, and student_tasks created successfully!'

    # # Creating StudentTask records for participants
    # puts "Filling missing attributes for Participants"
    # Participant.all.each do |participant|
    #   # Fill missing attributes with Faker data if they are nil
    #   participant.handle ||= Faker::Internet.username
    #   participant.topic ||= Faker::Lorem.sentence
    #   participant.current_stage ||= Faker::Lorem.word
    #   participant.stage_deadline ||= Time.zone.now + rand(1..4).weeks  # Random deadline between 1-4 weeks
  
    #   # Save the participant with the filled attributes
    #   participant.save!
  
    #   puts "Filled missing attributes for Participant ID: #{participant.id}"
    # end
  
    # # Creating StudentTask records for participants
    # puts "Creating StudentTask records for participants"
    # Participant.all.each_with_index do |participant, i|
    #   begin
    #     # Ensure required attributes are valid before creating the task
    #     task = StudentTask.create!(
    #       assignment: "Program #{(i % num_assignments) + 1}",
    #       topic: participant.topic,
    #       participant_id: participant.id,
    #       current_stage: participant.current_stage,
    #       stage_deadline: participant.stage_deadline,
    #       permission_granted: participant.permission_granted || false, # Default to false if nil
    #     )
    #     puts "✔ Created StudentTask for participant ID: #{participant.id}"
    #   rescue ActiveRecord::RecordInvalid => e
    #     puts "✘ Failed to create StudentTask for participant ID: #{participant.id} - #{e.message}"
    #   end
    # end


rescue ActiveRecord::RecordInvalid => e
    puts 'The db has already been seeded'
end
