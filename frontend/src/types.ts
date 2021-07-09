import type { Settings, User } from "./components/types"

export enum Color {
  primary = "--primary",
  darkPrimary = "--dark-primary",
  secondary = "--secondary",
  tertiary = "--tertiary",
  darkestGray = "--darkest-gray",
  white = "--white",
  transparent = "--transparent",
}

export enum Gap {
  xs = "--gap-xs",
  sm = "--gap-sm",
  md = "--gap-md",
  lg = "--gap-lg",
  xl = "--gap-xl",
}

export enum APIStatus {
  ok = "ok",
  error = "error",
};

export type APIResponse = {
  status: APIStatus;
  body: APIError | Array<URL> | User | Settings;
}

export type APIError = {
  field?: string;
  message: string;
}

export const getErrorFor = (key: string, error : APIError | null) => (error && key === error.field && error.message) || null;
