package DDG::Goodie::MilitaryRank;
# ABSTRACT: Return rank structure for a given military branch.

use DDG::Goodie;
use strict;

use Data::Dumper;
use feature qw(say);

zci answer_type => 'military_rank';
zci is_cached   => 1;

my $DATA = {
    ba => {
        army => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'http://en.wikipedia.org/wiki/Armed_Forces_of_Bosnia_and_Herzegovina'
            },
            data => [
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/d3/Bosnia_and_Herzegovina_Private_Insignia.svg',
                    title       => 'Vojnik',
                    altSubtitle => '',
                    subtitle    => 'OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c7/Bosnia_and_Herzegovina_Private_First_Class_Insignia.svg',
                    title       => 'Vojnik 1 klase',
                    altSubtitle => '',
                    subtitle    => 'OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/d8/Bosnia_and_Herzegovina_Corporal_Insignia.svg',
                    title       => 'Kaplar',
                    altSubtitle => '',
                    subtitle    => 'OR-3/4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/92/Bosnia_and_Herzegovina_Sergeant_Insignia.svg',
                    title       => 'Vodnik',
                    altSubtitle => '',
                    subtitle    => 'OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c1/Bosnia_and_Herzegovina_Staff_Sergeant_Insignia.svg',
                    title       => 'Stariji vodnik',
                    altSubtitle => '',
                    subtitle    => 'OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/53/Bosnia_and_Herzegovina_Sergeant_First_Class_Insignia.svg',
                    title       => 'Stariji vodnik 1',
                    altSubtitle => '',
                    subtitle    => 'OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e8/Bosnia_and_Herzegovina_Master_Sergeant_Insignia.svg',
                    title       => 'Zastavnik',
                    altSubtitle => '',
                    subtitle    => 'OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/93/Bosnia_and_Herzegovina_Sergeant_Major_Insignia.svg',
                    title       => 'Zastavnik 1 klase',
                    altSubtitle => '',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/45/Bosnia_and_Herzegovina_Lieutenant_Insignia.svg',
                    title       => 'Podporučnik',
                    altSubtitle => '',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c1/Bosnia_and_Herzegovina_1st_Lieutenant_Insignia.svg',
                    title       => 'Poručnik',
                    altSubtitle => '',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/be/Bosnia_and_Herzegovina_Captain_Insignia.svg',
                    title       => 'Kapetan',
                    altSubtitle => '',
                    subtitle    => 'OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/33/Bosnia_and_Herzegovina_Major_Insignia.svg',
                    title       => 'Major',
                    altSubtitle => '',
                    subtitle    => 'OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/57/Bosnia_and_Herzegovina_Colonel_Insignia.svg',
                    title       => 'Pukovnik',
                    altSubtitle => '',
                    subtitle    => 'OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/58/Bosnia_and_Herzegovina_Brigadier_Insignia.svg',
                    title       => 'Brigadir',
                    altSubtitle => '',
                    subtitle    => 'OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/97/Bosnia_and_Herzegovina_Brugadier-general_Insignia.svg',
                    title       => 'Brigadni general',
                    altSubtitle => '',
                    subtitle    => 'OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Bosnia_and_Herzegovina_Major-general_Insignia.svg',
                    title       => 'General major',
                    altSubtitle => '',
                    subtitle    => 'OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Bosnia_and_Herzegovina_Colonel-general_Insignia.svg',
                    title       => 'General pukovnik',
                    altSubtitle => '',
                    subtitle    => 'OF-8',
                },
            ],
        },
    },
    pl => {
        air_force => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'http://en.wikipedia.org/wiki/Polish_Armed_Forces_rank_insignia'
            },
            data => [
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/69/Rank_insignia_of_szeregowy_of_the_Air_Force_of_Poland.svg',
                    title       => 'szeregowy',
                    altSubtitle => 'szer.',
                    subtitle    => 'OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/62/Rank_insignia_of_starszy_szeregowy_of_the_Air_Force_of_Poland.svg',
                    title       => 'starszy szeregowy',
                    altSubtitle => 'st.szer.',
                    subtitle    => 'OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/ba/Rank_insignia_of_kapral_of_the_Air_Force_of_Poland.svg',
                    title       => 'kapral',
                    altSubtitle => 'kpr.',
                    subtitle    => 'OR-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/22/Rank_insignia_of_starszy_kapral_of_the_Air_Force_of_Poland.svg',
                    title       => 'starszy kapral',
                    altSubtitle => 'st.kpr.',
                    subtitle    => 'OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Rank_insignia_of_plutonowy_of_the_Air_Force_of_Poland.svg',
                    title       => 'plutonowy',
                    altSubtitle => 'plut.',
                    subtitle    => 'OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/82/Rank_insignia_of_sier%C5%BCant_of_the_Air_Force_of_Poland.svg',
                    title       => 'sierżant',
                    altSubtitle => 'sierż.',
                    subtitle    => 'OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Rank_insignia_of_starszy_sier%C5%BCant_of_the_Air_Force_of_Poland.svg',
                    title       => 'starszy sierżant',
                    altSubtitle => 'st.sierż.',
                    subtitle    => 'OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/55/Rank_insignia_of_m%C5%82odszy_chor%C4%85%C5%BCy_of_the_Air_Force_of_Poland.svg',
                    title       => 'młodszy chorąży',
                    altSubtitle => 'mł.chor.',
                    subtitle    => 'OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/f4/Rank_insignia_of_chor%C4%85%C5%BCy_of_the_Air_Force_of_Poland.svg',
                    title       => 'chorąży',
                    altSubtitle => 'chor.',
                    subtitle    => 'OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/de/Rank_insignia_of_starszy_chor%C4%85%C5%BCy_of_the_Air_Force_of_Poland.svg',
                    title       => 'starszy chorąży',
                    altSubtitle => 'st.chor.',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/56/Rank_insignia_of_starszy_chor%C4%85%C5%BCy_sztabowy_of_the_Air_Force_of_Poland.svg',
                    title       => 'starszy chorąży sztabowy',
                    altSubtitle => 'st.chor.szt.',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Rank_insignia_of_podporucznik_of_the_Air_Force_of_Poland.svg',
                    title       => 'podporucznik',
                    altSubtitle => 'ppor.',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c8/Rank_insignia_of_porucznik_of_the_Air_Force_of_Poland.svg',
                    title       => 'porucznik',
                    altSubtitle => 'por.',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/ad/Rank_insignia_of_kapitan_of_the_Air_Force_of_Poland.svg',
                    title       => 'kapitan',
                    altSubtitle => 'kpt.',
                    subtitle    => 'OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/1b/Rank_insignia_of_major_of_the_Air_Force_of_Poland.svg',
                    title       => 'major',
                    altSubtitle => 'mjr.',
                    subtitle    => 'OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/48/Rank_insignia_of_podpu%C5%82kownik_of_the_Air_Force_of_Poland.svg',
                    title       => 'podpułkownik',
                    altSubtitle => 'ppłk.',
                    subtitle    => 'OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/80/Rank_insignia_of_pu%C5%82kownik_of_the_Air_Force_of_Poland.svg',
                    title       => 'pułkownik',
                    altSubtitle => 'płk.',
                    subtitle    => 'OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/58/Rank_insignia_of_genera%C5%82_brygady_of_the_Air_Force_of_Poland.svg',
                    title       => 'generał brygady',
                    altSubtitle => 'gen.bryg.',
                    subtitle    => 'OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e2/Rank_insignia_of_genera%C5%82_dywizji_of_the_Air_Force_of_Poland.svg',
                    title       => 'generał dywizji',
                    altSubtitle => 'gen.dyw.',
                    subtitle    => 'OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/Rank_insignia_of_genera%C5%82_broni_of_the_Air_Force_of_Poland.svg',
                    title       => 'generał broni',
                    altSubtitle => 'gen.broni',
                    subtitle    => 'OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/17/Rank_insignia_of_genera%C5%82_of_the_Air_Force_of_Poland.svg',
                    title       => 'generał',
                    altSubtitle => 'gen.',
                    subtitle    => 'OF-9',
                },
            ],
        },
        army => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'http://en.wikipedia.org/wiki/Polish_Armed_Forces_rank_insignia'
            },
            data => [
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/0d/Army-POL-OR-01.svg',
                    title       => 'szeregowy',
                    altSubtitle => 'szer.',
                    subtitle    => 'OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/d6/Army-POL-OR-02.svg',
                    title       => 'starszy szeregowy',
                    altSubtitle => 'st.szer.',
                    subtitle    => 'OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e2/Army-POL-OR-03.svg',
                    title       => 'kapral',
                    altSubtitle => 'kpr.',
                    subtitle    => 'OR-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/71/Army-POL-OR-04b.svg',
                    title       => 'starszy kapral',
                    altSubtitle => 'st.kpr.',
                    subtitle    => 'OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/b8/Army-POL-OR-04a.svg',
                    title       => 'plutonowy',
                    altSubtitle => 'plut.',
                    subtitle    => 'OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/Army-POL-OR-05.svg',
                    title       => 'sierżant',
                    altSubtitle => 'sierż.',
                    subtitle    => 'OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/1b/Army-POL-OR-06.svg',
                    title       => 'starszy sierżant',
                    altSubtitle => 'st.sierż.',
                    subtitle    => 'OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/67/Army-POL-OR-07.svg',
                    title       => 'młodszy chorąży',
                    altSubtitle => 'mł.chor.',
                    subtitle    => 'OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/32/Army-POL-OR-08.svg',
                    title       => 'chorąży',
                    altSubtitle => 'chor.',
                    subtitle    => 'OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/5/52/Army-POL-OR-09b.svg',
                    title       => 'starszy chorąży',
                    altSubtitle => 'st.chor.',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/1c/Army-POL-OR-09a.svg',
                    title       => 'starszy chorąży sztabowy',
                    altSubtitle => 'st.chor.szt.',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/47/Army-POL-OF-01b.svg',
                    title       => 'podporucznik',
                    altSubtitle => 'ppor.',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/cd/Army-POL-OF-01a.svg',
                    title       => 'porucznik',
                    altSubtitle => 'por.',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/a0/Army-POL-OF-02.svg',
                    title       => 'kapitan',
                    altSubtitle => 'kpt.',
                    subtitle    => 'OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/00/Army-POL-OF-03.svg',
                    title       => 'major',
                    altSubtitle => 'mjr.',
                    subtitle    => 'OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/39/Army-POL-OF-04.svg',
                    title       => 'podpułkownik',
                    altSubtitle => 'ppłk.',
                    subtitle    => 'OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Army-POL-OF-05.svg',
                    title       => 'pułkownik',
                    altSubtitle => 'płk.',
                    subtitle    => 'OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/36/Army-POL-OF-06.svg',
                    title       => 'generał brygady',
                    altSubtitle => 'gen.bryg.',
                    subtitle    => 'OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/d8/Army-POL-OF-07.svg',
                    title       => 'generał dywizji',
                    altSubtitle => 'gen.dyw.',
                    subtitle    => 'OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/08/Army-POL-OF-08.svg',
                    title       => 'generał broni',
                    altSubtitle => 'gen.broni',
                    subtitle    => 'OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/04/Army-POL-OF-09.svg',
                    title       => 'generał',
                    altSubtitle => 'gen.',
                    subtitle    => 'OF-9',
                },
            ],
        },
        navy => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'http://en.wikipedia.org/wiki/Polish_Armed_Forces_rank_insignia'
            },
            data => [
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/0d/POL_PMW_pagon1_marynarz.svg',
                    title       => 'marynarz',
                    altSubtitle => 'mar.',
                    subtitle    => 'OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/30/POL_PMW_pagon1_starszy_marynarz.svg',
                    title       => 'starszy marynarz',
                    altSubtitle => 'st.mar.',
                    subtitle    => 'OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/37/POL_PMW_pagon1_mat.svg',
                    title       => 'mat',
                    altSubtitle => 'mat',
                    subtitle    => 'OR-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/a8/POL_PMW_pagon1_starszy_mat.svg',
                    title       => 'starszy mat',
                    altSubtitle => 'st.mat',
                    subtitle    => 'OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/9e/POL_PMW_pagon1_bosmanmat.svg',
                    title       => 'bosmanmat',
                    altSubtitle => 'bsmt.',
                    subtitle    => 'OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/a9/POL_PMW_pagon1_bosman.svg',
                    title       => 'bosman',
                    altSubtitle => 'bsm.',
                    subtitle    => 'OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/b0/POL_PMW_pagon1_starszy_bosman.svg',
                    title       => 'starszy bosman',
                    altSubtitle => 'st.bsm.',
                    subtitle    => 'OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/f6/POL_PMW_pagon1_m%C5%82odszy_chor%C4%85%C5%BCy_marynarki.svg',
                    title       => 'młodszy chorąży marynarki',
                    altSubtitle => 'mł.chor.mar.',
                    subtitle    => 'OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/b8/POL_PMW_pagon1_chor%C4%85%C5%BCy_marynarki.svg',
                    title       => 'chorąży marynarki',
                    altSubtitle => 'chor.mar.',
                    subtitle    => 'OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6b/POL_PMW_pagon1_starszy_chor%C4%85%C5%BCy_marynarki.svg',
                    title       => 'starszy chorąży marynarki',
                    altSubtitle => 'st.chor.mar.',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e1/POL_PMW_pagon1_starszy_chor%C4%85%C5%BCy_sztabowy_marynarki.svg',
                    title       => 'starszy chorąży sztabowy marynarki',
                    altSubtitle => 'st.chor.szt.mar.',
                    subtitle    => 'OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6c/POL_PMW_pagon1_podporucznik_marynarki.svg',
                    title       => 'podporucznik marynarki',
                    altSubtitle => 'ppor.mar.',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/af/POL_PMW_pagon1_porucznik_marynarki.svg',
                    title       => 'porucznik marynarki',
                    altSubtitle => 'por.mar.',
                    subtitle    => 'OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/2a/POL_PMW_pagon1_kapitan_marynarki.svg',
                    title       => 'kapitan marynarki',
                    altSubtitle => 'kpt.mar.',
                    subtitle    => 'OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/3f/POL_PMW_pagon1_komandor_podporucznik.svg',
                    title       => 'komandor podporucznik',
                    altSubtitle => 'kmdr.ppor.',
                    subtitle    => 'OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/28/POL_PMW_pagon1_komandor_porucznik.svg',
                    title       => 'komandor porucznik',
                    altSubtitle => 'kmdr.por.',
                    subtitle    => 'OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c4/POL_PMW_pagon1_komandor.svg',
                    title       => 'komandor',
                    altSubtitle => 'kmdr.',
                    subtitle    => 'OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/POL_PMW_pagon1_kontradmira%C5%82.svg',
                    title       => 'kontradmirał',
                    altSubtitle => 'kadm.',
                    subtitle    => 'OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8c/POL_PMW_pagon1_wiceadmira%C5%82.svg',
                    title       => 'wiceadmirał',
                    altSubtitle => 'wadm.',
                    subtitle    => 'OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/24/POL_PMW_pagon1_admira%C5%82_floty.svg',
                    title       => 'admirał floty',
                    altSubtitle => 'adm.fl.',
                    subtitle    => 'OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/98/POL_PMW_pagon1_admira%C5%82.svg',
                    title       => 'admirał',
                    altSubtitle => 'adm.',
                    subtitle    => 'OF-9',
                },
            ],
        },
    },
    us => {
        air_force => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'http://en.wikipedia.org/wiki/United_States_Air_Force_enlisted_rank_insignia'
            },
            data => [
            {
                    image       => '',
                    title       => 'Airman Basic',
                    altSubtitle => 'AB',
                    subtitle    => 'E-1 | OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/f5/E2_USAF_AM.svg',
                    title       => 'Airman',
                    altSubtitle => 'Amn',
                    subtitle    => 'E-2 | OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/7d/E3_USAF_AM1.svg',
                    title       => 'Airman First Class',
                    altSubtitle => 'A1C',
                    subtitle    => 'E-3 | OR-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/E4_USAF_SAM.svg',
                    title       => 'Senior Airman',
                    altSubtitle => 'SrA',
                    subtitle    => 'E-4 | OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/ea/E5_USAF_SSGT.svg',
                    title       => 'Staff Sergeant',
                    altSubtitle => 'SSgt',
                    subtitle    => 'E-5 | OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/fc/E6_USAF_TSGT.svg',
                    title       => 'Technical Sergeant',
                    altSubtitle => 'TSgt',
                    subtitle    => 'E-6 | OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/4e/E7a_USAF_MSGT.svg',
                    title       => 'Master Sergeant',
                    altSubtitle => 'MSgt',
                    subtitle    => 'E-7 | OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8b/E8a_USAF_SMSGT.svg',
                    title       => 'Senior Master Sergeant',
                    altSubtitle => 'SMSgt',
                    subtitle    => 'E-8 | OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/e/ef/E9a_USAF_CMSGT.svg',
                    title       => 'Chief Master Sergeant',
                    altSubtitle => 'CMSgt',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/36/E9c_USAF_CCMS.svg',
                    title       => 'Command Chief Master Sergeant',
                    altSubtitle => 'CCM',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8d/E9d_USAF_CMSAF.svg
                ',
                    title       => 'Chief Master Sergeant of the Air Force',
                    altSubtitle => 'CMSAF',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/US-O1_insignia.svg',
                    title       => 'Second Lieutenant',
                    altSubtitle => '2nd Lt',
                    subtitle    => 'O-1 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O2_insignia.svg',
                    title       => 'First Lieutenant',
                    altSubtitle => '1st Lt',
                    subtitle    => 'O-2 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O3_insignia.svg',
                    title       => 'Captain',
                    altSubtitle => 'Capt',
                    subtitle    => 'O-3 | OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8f/US-O4_insignia.svg',
                    title       => 'Major',
                    altSubtitle => 'Maj',
                    subtitle    => 'O-4 | OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/US-O5_insignia.svg',
                    title       => 'Lieutenant Colonel',
                    altSubtitle => 'Lt Col',
                    subtitle    => 'O-5 | OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c5/US-O6_insignia.svg',
                    title       => 'Colonel',
                    altSubtitle => 'Col',
                    subtitle    => 'O-6 | OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/US-O7_insignia.svg',
                    title       => 'Brigadier General',
                    altSubtitle => 'Brig Gen',
                    subtitle    => 'O-7 | OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/91/US-O8_insignia.svg',
                    title       => 'Major General',
                    altSubtitle => 'Maj Gen',
                    subtitle    => 'O-8 | OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/da/US-O9_insignia.svg',
                    title       => 'Lieutenant General',
                    altSubtitle => 'Lt Gen',
                    subtitle    => 'O-9 | OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/US-O10_insignia.svg',
                    title       => 'General',
                    altSubtitle => 'Gen',
                    subtitle    => 'O-10 | OF-9',
                },
            ],
        },
        army => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'http://wikipedia.org/wiki/United_States_Army_enlisted_rank_insignia'
            },
            data => [
                {
                    image => '',
                    title => 'Private',
                    altSubtitle => 'PV1',
                    subtitle => 'E-1 | OR-1',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/9/91/Army-USA-OR-02.svg',
                    title => 'Private',
                    altSubtitle => 'PV2',
                    subtitle => 'E-2 | OR-2',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Army-USA-OR-03.svg',
                    title => 'Private First Class',
                    altSubtitle => 'PFC',
                    subtitle => 'E-3 | OR-3',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/1/1c/Army-USA-OR-04b.svg',
                    title => 'Specialist',
                    altSubtitle => 'SPC',
                    subtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Army-USA-OR-04a.svg',
                    title => 'Corporal',
                    altSubtitle => 'CPL',
                    subtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/2/27/Army-USA-OR-05.svg',
                    title => 'Sergeant',
                    altSubtitle => 'SGT',
                    subtitle => 'E-5 | OR-5',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/0/0b/Army-USA-OR-06.svg',
                    title => 'Staff Sergeant',
                    altSubtitle => 'SSG',
                    subtitle => 'E-6 | OR-6',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/7/71/Army-USA-OR-07.svg',
                    title => 'Sergeant First Class',
                    altSubtitle => 'SFC',
                    subtitle => 'E-7 | OR-7',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Army-USA-OR-08b.svg',
                    title => 'Master Sergeant',
                    altSubtitle => 'MSG',
                    subtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Army-USA-OR-08a.svg',
                    title => 'First Sergeant',
                    altSubtitle => '1SG',
                    subtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Army-USA-OR-09c.svg',
                    title => 'Sergeant Major',
                    altSubtitle => 'SGM',
                    subtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/3/31/Army-USA-OR-09b.svg',
                    title => 'Command Sergeant Major',
                    altSubtitle => 'CSM',
                    subtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/f/f6/Army-USA-OR-09a.svg',
                    title => 'Sergeant Major of the Army',
                    altSubtitle => 'SMA',
                    subtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/e/e3/US-Army-WO1.svg',
                    title => 'Warrant Officer',
                    altSubtitle => 'W01',
                    subtitle => 'W-1 | WO-1',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/d/de/US-Army-CW2.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW2',
                    subtitle => 'W-2 | WO-2',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/2/2a/US-Army-CW3.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW3',
                    subtitle => 'W-3 | WO-3',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/4/42/US-Army-CW4.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW4',
                    subtitle => 'W-4 | WO-4',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/3/37/US-Army-CW5compare.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW5',
                    subtitle => 'W-5 | WO-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/US-O1_insignia.svg',
                    title       => 'Second Lieutenant',
                    altSubtitle => '2LT',
                    subtitle    => 'O-1 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O2_insignia.svg',
                    title       => 'First Lieutenant',
                    altSubtitle => '1LT',
                    subtitle    => 'O-2 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O3_insignia.svg',
                    title       => 'Captain',
                    altSubtitle => 'CPT',
                    subtitle    => 'O-3 | OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8f/US-O4_insignia.svg',
                    title       => 'Major',
                    altSubtitle => 'MAJ',
                    subtitle    => 'O-4 | OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/US-O5_insignia.svg',
                    title       => 'Lieutenant Colonel',
                    altSubtitle => 'LTC',
                    subtitle    => 'O-5 | OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c5/US-O6_insignia.svg',
                    title       => 'Colonel',
                    altSubtitle => 'COL',
                    subtitle    => 'O-6 | OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/US-O7_insignia.svg',
                    title       => 'Brigadier General',
                    altSubtitle => 'BG',
                    subtitle    => 'O-7 | OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/91/US-O8_insignia.svg',
                    title       => 'Major General',
                    altSubtitle => 'MG',
                    subtitle    => 'O-8 | OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/da/US-O9_insignia.svg',
                    title       => 'Lieutenant General',
                    altSubtitle => 'LG',
                    subtitle    => 'O-9 | OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/US-O10_insignia.svg',
                    title       => 'General',
                    altSubtitle => 'GEN',
                    subtitle    => 'O-10 | OF-9',
                },
            ],
        },
        marines => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'https://en.wikipedia.org/wiki/United_States_Marine_Corps_rank_insignia'
            },
            data => [
                {
                    image       => '',
                    title       => 'Private',
                    altSubtitle => 'Pvt',
                    subtitle    => 'E-1 | OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/17/USMC-E2.svg',
                    title       => 'Private First Class',
                    altSubtitle => 'PFC',
                    subtitle    => 'E-2 | OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/4e/USMC-E3.svg',
                    title       => 'Lance Corporal',
                    altSubtitle => 'LCpl',
                    subtitle    => 'E-3 | OR-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/24/USMC-E4.svg',
                    title       => 'Corporal',
                    altSubtitle => 'Cpl',
                    subtitle    => 'E-4 | OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/69/USMC-E5.svg',
                    title       => 'Sergeant',
                    altSubtitle => 'Sgt',
                    subtitle    => 'E-5 | OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/77/USMC-E6.svg',
                    title       => 'Staff Sergeant',
                    altSubtitle => 'SSgt',
                    subtitle    => 'E-6 | OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/f6/USMC-E7.svg',
                    title       => 'Gunnery Sergeant',
                    altSubtitle => 'GySgt',
                    subtitle    => 'E-7 | OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/3c/USMC-E8-MSG.svg',
                    title       => 'Master Sergeant',
                    altSubtitle => 'MSgt',
                    subtitle    => 'E-8 | OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/43/USMC-E8-1SG.svg',
                    title       => 'First Sergeant',
                    altSubtitle => '1stSgt',
                    subtitle    => 'E-8 | OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/a/aa/USMC-E9-MGyS.svg',
                    title       => 'Master Gunnery Sergeant',
                    altSubtitle => 'MGySgt',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/80/USMC-E9-SGM.svg',
                    title       => 'Sergeant Major',
                    altSubtitle => 'SgtMaj',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/38/USMC-E9-SGMMC.svg',
                    title       => 'Sergeant Major of the Marine Corps',
                    altSubtitle => 'SgtMajMarCor',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c4/USMC_WO1.svg',
                    title       => 'Warrant Officer',
                    altSubtitle => 'WO',
                    subtitle    => 'W-1 | WO-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/76/USMC_CWO2.svg',
                    title       => 'Chief Warrant Officer-2',
                    altSubtitle => 'CWO2',
                    subtitle    => 'W-2 | WO-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6f/USMC_CWO3.svg',
                    title       => 'Chief Warrant Officer-3',
                    altSubtitle => 'CWO3',
                    subtitle    => 'W-3 | WO-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/16/USMC_CWO4.svg',
                    title       => 'Chief Warrant Officer-4',
                    altSubtitle => 'CWO4',
                    subtitle    => 'W-4 | WO-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/47/USMC_CWO5.svg',
                    title       => 'Chief Warrant Officer-5',
                    altSubtitle => 'CWO5',
                    subtitle    => 'W-5 | WO-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/US-O1_insignia.svg',
                    title       => 'Second Lieutenant',
                    altSubtitle => '2ndLt',
                    subtitle    => 'O-1 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O2_insignia.svg',
                    title       => 'First Lieutenant',
                    altSubtitle => '1stLt',
                    subtitle    => 'O-2 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O3_insignia.svg',
                    title       => 'Captain',
                    altSubtitle => 'Capt',
                    subtitle    => 'O-3 | OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8f/US-O4_insignia.svg',
                    title       => 'Major',
                    altSubtitle => 'Maj',
                    subtitle    => 'O-4 | OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/US-O5_insignia.svg',
                    title       => 'Lieutenant Colonel',
                    altSubtitle => 'LtCol',
                    subtitle    => 'O-5 | OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c5/US-O6_insignia.svg',
                    title       => 'Colonel',
                    altSubtitle => 'Col',
                    subtitle    => 'O-6 | OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/US-O7_insignia.svg',
                    title       => 'Brigadier General',
                    altSubtitle => 'BGen',
                    subtitle    => 'O-7 | OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/91/US-O8_insignia.svg',
                    title       => 'Major General',
                    altSubtitle => 'MajGen',
                    subtitle    => 'O-8 | OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/da/US-O9_insignia.svg',
                    title       => 'Lieutenant General',
                    altSubtitle => 'LtGen',
                    subtitle    => 'O-9 | OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/US-O10_insignia.svg',
                    title       => 'General',
                    altSubtitle => 'Gen',
                    subtitle    => 'O-10 | OF-9',
                },

            ],
        },
        navy => {
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'https://en.wikipedia.org/wiki/List_of_United_States_Navy_enlisted_rates'
            },
            data => [
                {
                    image       => '',
                    title       => 'Seaman Recruit',
                    altSubtitle => 'SR',
                    subtitle    => 'E-1 | OR-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/17/E2_SM_USN.png',
                    title       => 'Seaman Apprentice',
                    altSubtitle => 'SA',
                    subtitle    => 'E-2 | OR-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/1/1e/E3_SM_USN.png',
                    title       => 'Seaman',
                    altSubtitle => 'SN',
                    subtitle    => 'E-3 | OR-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/49/PO3_GC.png',
                    title       => 'Petty Officer Third Class',
                    altSubtitle => 'PO3',
                    subtitle    => 'E-4 | OR-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/f/fc/PO2_GC.png',
                    title       => 'Petty Officer Second Class',
                    altSubtitle => 'PO2',
                    subtitle    => 'E-5 | OR-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/d7/PO1_GC.png',
                    title       => 'Petty Officer First Class',
                    altSubtitle => 'PO1',
                    subtitle    => 'E-6 | OR-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6a/CPO_GC.svg',
                    title       => 'Chief Petty Officer',
                    altSubtitle => 'CPO',
                    subtitle    => 'E-7 | OR-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/cc/SCPO_GC.svg',
                    title       => 'Senior Chief Petty Officer',
                    altSubtitle => 'SCPO',
                    subtitle    => 'E-8 | OR-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/bd/MCPO_GC.svg',
                    title       => 'Master Chief Petty Officer',
                    altSubtitle => 'MCPO',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/3/37/CMCPO.svg',
                    title       => 'Command Master Chief Petty Officer',
                    altSubtitle => 'CMDCM',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/cd/FMCPO.svg',
                    title       => 'Fleet Master Chief Petty Officer',
                    altSubtitle => 'FLTCM',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/cd/FMCPO.svg',
                    title       => 'Force Master Chief Petty Officer',
                    altSubtitle => 'FORCM',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/be/MCPON.svg',
                    title       => 'Master Chief Petty Officer of the Navy',
                    altSubtitle => 'MCPON',
                    subtitle    => 'E-9 | OR-9',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/44/US_Navy_CW2_insignia.svg
                ',
                    title       => 'Chief Warrant Officer',
                    altSubtitle => 'CWO2',
                    subtitle    => 'W-2 | WO-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/47/US_Navy_CW3_insignia.svg
                ',
                    title       => 'Chief Warrant Officer',
                    altSubtitle => 'CWO3',
                    subtitle    => 'W-3 | WO-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/b/b0/US_Navy_CW4_insignia.svg
                ',
                    title       => 'Chief Warrant Officer',
                    altSubtitle => 'CWO4',
                    subtitle    => 'W-4 | WO-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/2c/US_Navy_CW5_insignia.svg',
                    title       => 'Chief Warrant Officer',
                    altSubtitle => 'CWO5',
                    subtitle    => 'W-5 | WO-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/US-O1_insignia.svg',
                    title       => 'Ensign',
                    altSubtitle => 'ENS',
                    subtitle    => 'O-1 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O2_insignia.svg',
                    title       => 'Lieutenant Junior Grade',
                    altSubtitle => 'LTJG',
                    subtitle    => 'O-2 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O3_insignia.svg',
                    title       => 'Lieutenant',
                    altSubtitle => 'LT',
                    subtitle    => 'O-3 | OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8f/US-O4_insignia.svg',
                    title       => 'Lieutenant Commander',
                    altSubtitle => 'LCDR',
                    subtitle    => 'O-4 | OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/US-O5_insignia.svg',
                    title       => 'Commander',
                    altSubtitle => 'CDR',
                    subtitle    => 'O-5 | OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c5/US-O6_insignia.svg',
                    title       => 'Captain',
                    altSubtitle => 'CAPT',
                    subtitle    => 'O-6 | OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/US-O7_insignia.svg',
                    title       => 'Rear Admiral (Lower Half)',
                    altSubtitle => 'RDML',
                    subtitle    => 'O-7 | OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/91/US-O8_insignia.svg',
                    title       => 'Rear Admiral (Upper Half)',
                    altSubtitle => 'RADM',
                    subtitle    => 'O-8 | OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/da/US-O9_insignia.svg',
                    title       => 'Vice Admiral',
                    altSubtitle => 'VADM',
                    subtitle    => 'O-9 | OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/US-O10_insignia.svg',
                    title       => 'Admiral',
                    altSubtitle => 'ADM',
                    subtitle    => 'O-10 | OF-9',
                },
            ],
        },
    },
};

my $DISPLAY_NAME_FOR = {
    ba        => 'Bosnia and Herzegovina',
    pl        => 'Poland',
    us        => 'United States',
    air_force => 'Air Force',
    army      => 'Army',
    marines   => 'Marine Corps',
    navy      => 'Navy',
};

my $PATTERNS = {
    countries => {
        ba => 'bosnia and herzegovina|bosnian?|bih',
        pl => 'poland|polish',
        us => 'united states|u\.?s\.?a?\.?',
    },
    branches => {
        air_force => 'air ?forces?|af',
        army      => 'army|(?:armed|ground|land) forces?|military',
        marines   => 'marines?(?:\s+corps)?',
        navy      => 'navy',
    },
    # Note: Currently do nothing with $grade. Eventually maybe we could add a highlight to a section? Or only return one section? Or scroll the results to that rank?
    grades => {
        enlisted => 'enlisted',
        warrant  => '(?:chiefs?\s+)?warrants?(?:\s+officers?)?',
        officer  => 'officers?|generals?(?:\s+officers?)?',
    },
    keywords => {
        rank     => 'ranks?(?:\s+insignias?)?(?:\s+symbols?)?(?:\s+structure)?',
        insignia => 'insignias?',
        symbols  =>'symbols?',
        rates    => 'rates?',
    },
};

my $country_pat = join '|', values %{$PATTERNS->{countries}};
my $branch_pat  = join '|', values %{$PATTERNS->{branches}};
my $grade_pat   = join '|', values %{$PATTERNS->{grades}};
my $keywords    = join '|', values %{$PATTERNS->{keywords}};

my $complete_regex = qr/(?:($country_pat)\s+)?($branch_pat)\s+(?:$grade_pat\s+)?(?:$keywords)/i;

triggers query_clean => $complete_regex;

handle words => sub {
    my ($country, $branch) = $_ =~ $complete_regex;

    # TODO: Localize this default to the country of the searcher.
    $country = 'us' unless $country; # Default $country to us. 
    $country = get_key_from_pattern_hash($PATTERNS->{countries}, $country);

    $branch = get_key_from_pattern_hash($PATTERNS->{branches}, $branch);

    my $text_response = join ' ', ($DISPLAY_NAME_FOR->{$country}, $DISPLAY_NAME_FOR->{$branch}, 'Rank');

    my $structured_answer = $DATA->{$country}->{$branch};
    $structured_answer->{templates} = {
        group       => 'media',
        detail      => 'false',
        item_detail => 'false',
        variants => { tile => 'narrow' },
        # Scales oversize images to fit instead of clipping them.
        elClass  => { tileMedia => 'tile__media--pr' },
    };
    # To protect against "Use of uninitialized value in concatenation (.)
    # or string at .../App/DuckPAN/Web.pm line 447."
    $structured_answer->{id} = 'military_rank';

    return $text_response, structured_answer => $structured_answer;
};

sub get_key_from_pattern_hash {
    my ($hash, $subject) = @_;
    while ( my ($key, $pat) = each %$hash ) {
        return $key if $subject =~ qr/$pat/i;
    }
    return 0;
}

1;
