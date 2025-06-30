#!/bin/bash

# File creation
TODO_FILE="$HOME/kodecamp/todo.txt"
touch "$TODO_FILE"

# Function to display the menu
show_menu() {
    echo "============================"
    echo "        TO-DO-LIST"
    echo "============================"
    echo "1. View all tasks"
    echo "2. Add a new task"
    echo "3. Delete a task"
    echo "4. Exit the program"
    echo "============================"
}

view_tasks() {
    echo ""
    echo "Your Tasks:"
    echo "----------"
    
    # Check if todo file exists and is not empty
    if [[ -f "$TODO_FILE" && -s "$TODO_FILE" ]]; then
        nl -b a "$TODO_FILE"
    else
        echo "No tasks found. Your todo list is empty"
    fi
    echo ""
}

# Reusable function to get valid user input
validate_yes_no() {
    local prompt="$1"
    local user_input
    
    while true; do
        read -p "$prompt" user_input
        user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
        
        case "$user_input" in
            y|yes)
                echo "yes"
                return 0
                ;;
            n|no)
                echo "no"
                return 0
                ;;
            *)
                printf "❌ Invalid input! Please enter 'y' for yes or 'n' for no.\n" >&2
                ;;
        esac
    done
}

# Function to add tasks to the to-do list
add_tasks() {
    echo ""
    echo "Add a new task:"
    echo "---------------"
    
    local task_count=0
    local continue_adding="yes"
    
    while [[ "$continue_adding" == "yes" ]]; do
        read -p "Enter your new task: " new_task
        
        # Check if task is not empty
        if [[ -n "$new_task" ]]; then
            # Append new task to the todo file
            echo "$new_task" >> "$TODO_FILE"
            echo "$new_task: added"
            ((task_count++))
            echo ""
            
            continue_adding=$(validate_yes_no "Add another task? (y/n): ")
        else
            echo "Error: Task cannot be empty!"
            echo ""
            continue_adding=$(validate_yes_no "Try again? (y/n): ")
        fi
    done
    
    echo ""
    if [[ $task_count -gt 0 ]]; then
        echo "Successfully added $task_count task(s)!"
    else
        echo "No tasks were added"
    fi
    echo ""
}

# Function to delete todo
delete_tasks() {
    echo ""
    echo "Delete a task in your todo:"
    echo "---------------------------"
    
    if [[ -f "$TODO_FILE" && -s "$TODO_FILE" ]]; then
        # List out the tasks present
        echo "Current tasks:"
        nl -b a "$TODO_FILE"
        echo ""
        
        # Get the total number of tasks present
        total_tasks=$(wc -l < "$TODO_FILE")
        
        read -p "Enter the task number to delete (1-$total_tasks): " task_number
        
        # Validate Input
        if [[ "$task_number" =~ ^[0-9]+$ ]] && [[ "$task_number" -ge 1 ]] && [[ "$task_number" -le "$total_tasks" ]]; then
            # Delete the specified line using sed
            sed -i "${task_number}d" "$TODO_FILE"
            echo "Task #$task_number was deleted successfully!"
            sleep 2
            echo ""
            echo "Your new todo list is: "
            nl -b a "$TODO_FILE"
            echo ""
        else
            echo "Error: Invalid task number! Please enter a number between 1 and $total_tasks."
        fi
    else
        echo "No tasks found. Your todo list is empty!"
    fi
    echo ""
}

# Function to exit program
exit_program() {
    echo ""
    echo "Thank you for using Todo List Manager!"
    echo "Your tasks are saved in: $TODO_FILE"
    echo "Goodbye!"
    exit 0
}

# The main menu loop
main() {
    # Create todo file if it doesn't exist
    touch "$TODO_FILE"
    
    echo "Welcome to Todo List Manager!"
    echo "Your tasks will be saved in: $TODO_FILE"
    echo ""
    
    while true; do
        show_menu
        read -p "Please choose a number(1-4): " choice
        
        case $choice in
            1)
                view_tasks
                ;;
            2)
                add_tasks
                ;;
            3)
                delete_tasks
                ;;
            4)
                exit_program
                ;;
            *)
                echo ""
                echo "Invalid Option! Please choose 1, 2, 3, or 4."
                echo ""
                ;;
        esac
        
        # Pause before showing menu again (except for option 4 which is exit)
        if [[ $choice != 4 ]] && [[ $choice != 1 ]]; then
            read -p "Press Enter to continue..."
            clear
        fi
    done
}

# Run the main function
main