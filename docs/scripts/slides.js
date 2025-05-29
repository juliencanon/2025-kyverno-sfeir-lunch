import { SfeirThemeInitializer } from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
    "00_Intro.md",
    "02_Speaker.md",
    "03_40m.md",
    "05_Contexte.md",
    "07_Conformite.md"
  ];
}


function formation() {
  return [
    ...schoolSlides(),
  ].map((slidePath) => {
    return { path: slidePath };
  });
}

SfeirThemeInitializer.init(formation);
