const isNotNullObject = (object: unknown): boolean => {
  return typeof object === 'object' && object !== null;
};

const isNotEmptyString = (string: unknown): boolean => {
  return typeof string === 'string' && string.trim() !== '';
};

const isUnsetOrNotEmptyString = (string: unknown): boolean => {
  return typeof string === 'undefined' || string === null || isNotEmptyString(string);
};

const isNullOrNotEmptyString = (string: unknown): boolean => {
  return string === null || isNotEmptyString(string);
};

const isValidUUIDString = (uuid: unknown): boolean => {
  return isNotEmptyString(uuid) && /^[0-9a-f]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-f]{12}$/.test(<string>uuid);
};

const isValidDate = (date: unknown): boolean => {
  return date instanceof Date && date.toString() !== 'Invalid Date';
};

const isValidDateString = (date: unknown): boolean => {
  return isValidDate(new Date(<string>date));
};

const isValidNumber = (num: unknown): boolean => {
  return typeof num === 'number' && !isNaN(Number(num));
};

const isStringNumeric = (num: unknown): boolean => {
  return typeof num === 'string' && !isNaN(Number(num));
};

const isBoolean = (boolean: unknown) : boolean => {
  return typeof boolean === 'boolean';
};

export {
  isNotNullObject,
  isNotEmptyString,
  isNullOrNotEmptyString,
  isUnsetOrNotEmptyString,
  isValidUUIDString,
  isValidDate,
  isValidDateString,
  isValidNumber,
  isStringNumeric,
  isBoolean,
};
