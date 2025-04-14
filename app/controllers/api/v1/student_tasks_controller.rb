class Api::V1::StudentTasksController < ApplicationController
  # List retrieves all student tasks associated with the current logged-in user.
  def action_allowed?
    has_privileges_of?('Student')
  end

  def list
    # Retrieves all tasks that belong to the current user.
    @student_tasks = StudentTask.from_user(current_user)
    # Render the list of student tasks as JSON.
    # render json: @student_tasks, status: :ok
    render json: @student_tasks.map { |task| task_detail(task) }, status: :ok # TODO: updated
  end

  # TODO: Renders full task detail (same as `view`)
  def show
    # render json: @student_task, status: :ok
    @student_task = StudentTask.from_participant_id(params[:id]) # TODO: updated
    render json: task_detail(@student_task), status: :ok # TODO: updated
  end

  # The view function retrieves a student task based on a participant's ID.
  # It is meant to provide an endpoint where tasks can be queried based on participant ID.
  def view
    # Retrieves the student task where the participant's ID matches the provided parameter.
    # This function will be used for clicking on a specific student task to "view" its details.
    @student_task = StudentTask.from_participant_id(params[:id])
    # Render the found student task as JSON.
    # render json: @student_task, status: :ok
    render json: task_detail(@student_task), status: :ok # TODO: updated
  end

  # TODO: updated
  private

  # TODO: updated
  def task_detail(task)
    {
      assignment: {
        name: task.assignment,
        course: task.participant.assignment.course.name,
        topic: task.topic
      },
      current_stage: task.current_stage,
      participant: {
        id: task.participant.id,
        permissions: task.participant.permissions || []
      },
      stage_deadline: task.stage_deadline.strftime('%b %d, %Y, %I:%M %p'),
      stages: generate_stages(task),
      permission_granted: task.permission_granted
    }
  end

  # TODO: updated
  def generate_stages(task)
    stages = %w[submission review revision final]
    stages.map do |stage|
      {
        name: stage_title(stage),
        status: stage_status(stage, task.current_stage),
        date: dummy_deadline_for(stage)
      }
    end
  end

  # TODO: updated
  def stage_title(stage)
    {
      'submission' => 'Submission',
      'review' => 'Review',
      'revision' => 'Revision',
      'final' => 'Final Grade'
    }[stage] || stage.capitalize
  end

  # TODO: updated
  def stage_status(stage, current_stage)
    all = %w[submission review revision final]
    cs = current_stage.to_s.downcase
    if stage == cs
      'current'
    elsif all.index(stage) < all.index(cs)
      'completed'
    else
      'pending'
    end
  end

  # TODO: updated
  def dummy_deadline_for(stage)
    {
      'submission' => '2024-03-14',
      'review' => '2024-03-16',
      'revision' => '2024-03-18',
      'final' => '2024-03-20'
    }[stage] || Time.now.strftime('%Y-%m-%d')
  end
end
