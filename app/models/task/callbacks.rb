class Task
  
  before_create :init_task
  after_create :log_create
  after_save :set_watchers
  after_destroy :clear_targets

  def init_task
    self.position ||= task_list.tasks.last ? task_list.tasks.last.position + 1 : 0
  end

  def log_create(creator_id = nil)
    project.log_activity(self, 'create', creator_id) unless Teambox.config.push_new_activities? && dont_push
  end

  def set_watchers
    add_watcher(assigned.user) if assigned
    true
  end

  def clear_targets
    Activity.destroy_all  :target_id => self.id, :target_type => self.class.to_s
    Comment.destroy_all   :target_id => self.id, :target_type => self.class.to_s
  end
end  
