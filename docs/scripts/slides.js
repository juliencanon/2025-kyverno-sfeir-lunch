import { SfeirThemeInitializer } from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
    "00_Intro.md",
    "03_40m.md",
    "05_Contexte.md",
    "10_niveau_101.md",
    "15_Comment.md",
    "20_niveau_200.md",
    "30_niveau_300.md",
    "40_niveau_400.md",
    "45_Policy_reporter.md",
    "60_toolbox.md",
    "70_Mutate.md",
    "75_Generating.md",
    "80_supply.md",
    "85_clean.md",
    "87_vap_map.md",
    "90_Conclusion.md",
    "95_Speaker.md",
    "99_Questions.md"
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
