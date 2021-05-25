require "active_record"

class Todo < ActiveRecord::Base
  #find if the date is today
  def due_today?
    due_date == Date.today
  end

  #From Todo-list get each Todo and send to_displayable_string
  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  #display the value with id
  #if completed, mentioned also the Todo
  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  #Display the Todo-list with patterns
  def self.show_list
    date = Date.today
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts where("due_date<?", date).to_displayable_list
    puts "\n\n"

    puts "Due Today\n"
    puts where("due_date=?", date).to_displayable_list
    puts "\n\n"

    puts "Due Later\n"
    puts where("due_date>?", date).to_displayable_list
    puts "\n\n"
  end

  #insert a new Todo
  def self.add_task(h)
    create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  #update Todo is completed with help of id
  def self.mark_as_complete(todo_id)
    todo = find_by(id: todo_id)
    if (todo) #there is id,then update
      todo.completed = true
      todo.save!
      return todo
    end
    puts "Error! Invalid id" #else, print message and exit from here
    exit
  end
end
