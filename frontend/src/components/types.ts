export enum InputType {
  text = "text",
  number = "number",
  url = "url",
}

export enum ButtonType {
  submit = "submit",
  button = "button",
}

export enum IconName {
  trash = "trash",
  edit = "edit",
  send = "paper-plane",
  close = "times",
}

export enum Size {
  sm = "small",
  md = "medium",
};

export type Settings = {
  shortUrl: string;
};

export type User = {
  id: number;
  given_name: string;
};

export type URL = {
  id: number;
  redirect_to: string;
  path: string;
  user_id: number;
  is_private: boolean;
};
