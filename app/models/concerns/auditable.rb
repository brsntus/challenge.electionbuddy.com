module Auditable
  extend ActiveSupport::Concern

  included do
    has_many :audits, as: :auditable

    after_create do |entity|
      create_audit(entity, :create)
    end

    after_update do |entity|
      create_audit(entity, :update)
    end

    after_destroy do |entity|
      create_audit(entity, :destroy)
    end
  end

  private

  def create_audit(entity, type)
    Audit.create(
      user: User.first,
      auditable: entity,
      audit_changes: entity.saved_changes,
      audit_type: type
    )
  end
end
