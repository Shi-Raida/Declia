-- Create availability_rule_type enum
CREATE TYPE availability_rule_type AS ENUM ('recurring', 'override', 'blocked');

-- Create availability_rules table
CREATE TABLE availability_rules (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  rule_type   availability_rule_type NOT NULL,
  day_of_week SMALLINT,
  specific_date DATE,
  start_time  TIME,
  end_time    TIME,
  label       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Recurring rule: requires day_of_week + times
  CONSTRAINT chk_recurring CHECK (
    rule_type != 'recurring'
    OR (day_of_week IS NOT NULL AND start_time IS NOT NULL AND end_time IS NOT NULL)
  ),
  -- Override rule: requires specific_date + times
  CONSTRAINT chk_override CHECK (
    rule_type != 'override'
    OR (specific_date IS NOT NULL AND start_time IS NOT NULL AND end_time IS NOT NULL)
  ),
  -- Blocked rule: requires specific_date
  CONSTRAINT chk_blocked CHECK (
    rule_type != 'blocked'
    OR specific_date IS NOT NULL
  ),
  -- Times: start must be before end (only when both are present)
  CONSTRAINT chk_time_order CHECK (
    start_time IS NULL OR end_time IS NULL OR start_time < end_time
  ),
  -- day_of_week must be 0-6 (0 = Sunday, 1 = Monday, ... 6 = Saturday)
  CONSTRAINT chk_day_of_week CHECK (
    day_of_week IS NULL OR (day_of_week >= 0 AND day_of_week <= 6)
  )
);

-- Index on tenant_id for fast per-tenant queries
CREATE INDEX idx_availability_rules_tenant_id ON availability_rules(tenant_id);

-- Trigger to auto-update updated_at
CREATE TRIGGER set_updated_at_availability_rules
  BEFORE UPDATE ON availability_rules
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- RLS
ALTER TABLE availability_rules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tenants can view their own availability rules"
  ON availability_rules FOR SELECT
  USING (tenant_id = current_user_tenant_id());

CREATE POLICY "Tenants can insert their own availability rules"
  ON availability_rules FOR INSERT
  WITH CHECK (tenant_id = current_user_tenant_id());

CREATE POLICY "Tenants can update their own availability rules"
  ON availability_rules FOR UPDATE
  USING (tenant_id = current_user_tenant_id());

CREATE POLICY "Tenants can delete their own availability rules"
  ON availability_rules FOR DELETE
  USING (tenant_id = current_user_tenant_id());
