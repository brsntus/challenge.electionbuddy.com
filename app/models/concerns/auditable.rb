module Auditable
  extend ActiveSupport::Concern

  SKIP_FIELDS = %w[updated_at created_at].freeze

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
    return unless should_audit?(entity, type)

    Audit.create!(
      user: User.current_user,
      auditable: entity,
      audit_changes: get_auditable_changes(entity, type),
      audit_type: type
    )
  end

  def should_audit?(entity, type)
    type == :destroy || auditable_fields(entity).present?
  end

  def get_auditable_changes(entity, type)
    return {} unless type == :update

    entity.saved_changes.slice(*auditable_fields(entity))
  end

  def auditable_fields(entity)
    @_auditable_fields ||= entity.saved_changes.keys - SKIP_FIELDS
  end
end
