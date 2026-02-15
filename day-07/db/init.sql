CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
  id            BIGSERIAL PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE,
  email         TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_users_email ON users(email);
CREATE UNIQUE INDEX IF NOT EXISTS ux_users_username ON users(username);
