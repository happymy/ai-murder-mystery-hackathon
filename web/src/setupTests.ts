import '@testing-library/jest-dom';

window.matchMedia = window.matchMedia || function () {
  return { matches: false, addListener: function () {}, removeListener: function () {}, addEventListener: function () {}, removeEventListener: function () {}, dispatchEvent: function () {} };
};

jest.mock('nanoid', () => ({
  nanoid: () => 'test-session-id',
}));

jest.mock('react-i18next', () => ({
  useTranslation: () => ({
    t: (key: string, params?: Record<string, unknown>) => {
      if (params && 'name' in params) {
        return `${key}: ${params.name}`;
      }
      return key;
    },
    i18n: {
      changeLanguage: jest.fn(),
      language: 'en',
    },
  }),
  initReactI18next: {
    type: '3rdParty',
    init: jest.fn(),
  },
}));
