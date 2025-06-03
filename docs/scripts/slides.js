import { SfeirThemeInitializer } from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
    "00_Intro.md",
    "02_Speaker.md",
    "03_40m.md",
    "05_Contexte.md",
    "30_Kyverno.md",
    "40_Policy_reporter.md",
    "99_Conclusion.md"
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
