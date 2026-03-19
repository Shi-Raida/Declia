CREATE OR REPLACE FUNCTION public.distinct_client_tags()
  RETURNS SETOF TEXT
  LANGUAGE sql
  SECURITY INVOKER
  STABLE
AS $$
  SELECT DISTINCT unnest(tags) AS tag FROM public.clients ORDER BY tag;
$$;
