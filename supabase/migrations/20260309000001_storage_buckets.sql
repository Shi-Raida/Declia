-- Create storage buckets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('avatars',        'avatars',        false, 5242880,   ARRAY['image/jpeg','image/png','image/webp']),
  ('gallery-photos', 'gallery-photos', false, 52428800,  ARRAY['image/jpeg','image/png','image/webp','image/tiff']),
  ('documents',      'documents',      false, 10485760,  ARRAY['application/pdf']);

-- RLS policies: users can only access files in their tenant's folder
-- Convention: files stored under {tenant_id}/{user_id}/filename

-- avatars: users can read/write their own avatar
CREATE POLICY "Users can upload their own avatar"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "Users can view their own avatar"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'avatars' AND
    (storage.foldername(name))[1] = auth.uid()::text
  );

-- gallery-photos: tenant-scoped access (photographer uploads, clients read)
CREATE POLICY "Tenant members can view gallery photos"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'gallery-photos' AND
    (storage.foldername(name))[1] IN (
      SELECT tenant_id::text FROM public.users WHERE id = auth.uid()
    )
  );

CREATE POLICY "Photographers can upload gallery photos"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'gallery-photos' AND
    (storage.foldername(name))[1] IN (
      SELECT tenant_id::text FROM public.users
      WHERE id = auth.uid() AND role = 'photographer'
    )
  );

-- documents: tenant-scoped, photographer only
CREATE POLICY "Photographers can manage documents"
  ON storage.objects FOR ALL
  TO authenticated
  USING (
    bucket_id = 'documents' AND
    (storage.foldername(name))[1] IN (
      SELECT tenant_id::text FROM public.users
      WHERE id = auth.uid() AND role = 'photographer'
    )
  );
