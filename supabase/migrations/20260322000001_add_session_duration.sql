ALTER TABLE public.sessions
  ADD COLUMN duration_minutes INT NOT NULL DEFAULT 60;
