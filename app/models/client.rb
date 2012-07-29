class Client < ActiveRecord::Base
  belongs_to :event
  has_many :forms
  
  before_save :update_first_letter
 
  REQUIRED = :legal_name, :address_1
  REQUIRED.each do |s|
    validates s, :presence => true
  end
  
  validates :kingdom, :format => {
    :with => %r{^[^-]},
    :message => 'Please enter a kingdom'
  }
  
  JOINS = 'inner join forms f on f.client_id = clients.id'
  scope :needs_review, lambda { |event_id| joins(JOINS)\
                               .where('f.needs_review = 1 and event_id = ?', event_id)\
                               .group('clients.id')}
  scope :needs_printing, lambda { |event_id| joins(JOINS)\
                              .where('f.needs_review = 0 AND f.printed = 0 and event_id = ?', event_id)\
                              .group('clients.id')}
  scope :todays, lambda {|event_id| joins(JOINS)\
    .where('f.date_submitted = ? and event_id = ?', Date.today, event_id)\
    .group('clients.id')}
  scope :every, lambda {|event_id| where('event_id = ?', event_id) }
  def self.find_with_event(client_id, event) 
     self.find_by_id_and_event_id(client_id, event)
  end

  def self.scope_names
    {:needs_review => 'Show needs review',
     :needs_printing => 'Show needs printing',
     :todays => "Show today's",
     :every => 'Show all'}
  end

  def self.get_counts(scope, event_id)
    logger.info("Getting counts for scope #{scope} and event id #{event_id}")
    self.send(scope, event_id).group(:first_letter).order(:first_letter).count
  end
  
  def has_forms?
    not forms.empty?
  end
  
  def display_name
    society_name.blank? ? "<#{legal_name}>" : society_name
  end
  
  def required?(field)
    REQUIRED.include? field
  end
  
  private 
  def update_first_letter
    self.first_letter = (society_name || legal_name || "")[0..0]
  end
end
