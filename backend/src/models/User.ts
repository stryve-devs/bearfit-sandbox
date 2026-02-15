export interface User {
    user_id: number;
    name: string;
    email: string;
    username?: string;
    password_hash: string;
    role?: string;
    is_active?: boolean;
}