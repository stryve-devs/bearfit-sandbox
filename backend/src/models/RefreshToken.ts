export interface RefreshToken {
  id: number;
  token: string;
  user_id: number;
  expires_at: Date;
  revoked: boolean;
  created_at: Date;
}
