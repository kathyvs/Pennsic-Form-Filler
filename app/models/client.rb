class Client < ActiveRecord::Base
  belongs_to :event
  has_many :forms
 
  REQUIRED = :legal_name, :address_1, :address_2, :kingdom
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

  def self.scopes
    {:needs_review => 'Show needs review',
     :needs_printing => 'Show needs printing',
     :todays => "Show today's",
     :every => 'Show all'}
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
  end
