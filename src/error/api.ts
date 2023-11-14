class ApiError extends Error {
  public code: string;
  public message: string;
  public status: number;

  constructor(code: string, message: string, status = 400) {
    super(message);

    this.code = code;
    this.message = message;
    this.status = status;
  }
}

export default ApiError;
