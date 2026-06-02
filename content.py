# content.py — all site content lives here.
# Edit this file and run `python build.py` to regenerate docs/index.html.

SITE = {
    "title": "Gustavo Violato — Wind Turbine Engineering & Data Systems",
    "description": (
        "Senior wind turbine engineer and CTO with 15 years at the intersection "
        "of aeroelastic simulation, probabilistic design, and data engineering. "
        "6 granted patents. Contributor to IEC TS 61400-9:2025."
    ),
    "url": "https://gviolato.com",
}

PROFILE = {
    "name": "Gustavo Violato",
    "subtitle": "Wind Turbine Engineering & Data Systems",
    "tagline": (
        "15 years at the intersection of wind turbine engineering and engineering computation. "
        "6 granted patents. Contributor to IEC TS 61400-9. CTO of Oportunidados."
    ),
    "linkedin": "https://www.linkedin.com/in/gviolato/",
    "location": "Remote",
    "photo": "assets/images/gustavo.jpg",
    "photo_initials": "GV",
}

ABOUT = [
    (
        "My work sits at a specific and rarely combined intersection: deep expertise in wind turbine "
        "aeroelastic simulation, structural reliability, and probabilistic design — built over 15 years "
        "at companies including Vestas Wind Systems — and the software and data engineering practice to "
        "implement these methods at scale. I hold 6 granted patents and served as Secretary of the IEC TC88 "
        "project team that produced IEC TS 61400-9:2025, the wind industry's first international standard "
        "for probabilistic design of wind turbines."
    ),
    (
        "More recently, I stepped away from that track to co-found and lead the technical organisation of "
        "Oportunidados, a business intelligence startup in Brazil. As CTO, I built production-grade data "
        "engineering pipelines, a full-stack web platform, and a technical team from the ground up — "
        "navigating the AI inflection point of 2024–2025 with a commercial product serving enterprise "
        "clients. That experience gave me a practitioner's understanding of what it takes to build and "
        "operate data-intensive software systems, not just design them."
    ),
    (
        "I am now available for consulting engagements and senior technical roles at the boundary of wind "
        "energy engineering and data infrastructure. If you are working on problems that require both "
        "physics-based simulation expertise and modern software and data engineering practice, I would be "
        "glad to discuss how I can help."
    ),
]

SERVICES = [
    {
        "title": "Aeroelastic Simulation & Load Analysis",
        "desc": (
            "Design load calculations, load verification campaigns, and turbine certification support "
            "using industry-standard simulation tools."
        ),
        "bullets": [
            "Flex5/VTS, HAWC2, HAWC2Stab, FAST/OpenFAST, Bladed",
            "Load verification for technology feasibility and type certification",
            "Stability analysis and controller validation",
        ],
    },
    {
        "title": "Probabilistic Design & Reliability",
        "desc": (
            "Application and calibration of probabilistic structural design methods for wind turbines, "
            "including safety factor derivation and risk-based assessment."
        ),
        "bullets": [
            "IEC 61400-1 and IEC TS 61400-9 compliance and interpretation",
            "Structural reliability analysis (FORM/SORM)",
            "Safety factor calibration for fatigue and extreme loads",
        ],
    },
    {
        "title": "Model Validation & Certification",
        "desc": (
            "Aeroelastic model validation against field measurements, design of validation frameworks, "
            "and certification strategy."
        ),
        "bullets": [
            "IECRE/TC88 model validation framework",
            "Aeroelastic model uncertainty quantification",
            "Field data analysis and model–measurement correlation",
        ],
    },
    {
        "title": "Engineering Data Systems",
        "desc": (
            "Data engineering and software tooling for simulation workflows, field data processing, "
            "and engineering insight at scale."
        ),
        "bullets": [
            "Simulation pipeline automation",
            "Cloud data infrastructure and ETL pipelines",
            "Post-processing tooling for large simulation datasets",
        ],
    },
]

EXPERIENCE = [
    {
        "period": "Mar 2024 – Present",
        "role": "Technical Director / CTO",
        "company": "Oportunidados",
        "location": "Curitiba, Brazil · Remote",
        "desc": (
            "Built and led the technical organisation of a business intelligence startup from inception — "
            "data engineering pipelines (DBT, Airflow), full-stack platform (Ruby on Rails + Vue), "
            "cloud infrastructure (GCP), and technical team hiring and management. Navigated integration "
            "of LLM-based features into production during the AI inflection point of 2024–2025."
        ),
    },
    {
        "period": "Oct 2021 – Feb 2024",
        "role": "Specialist — Value Stream Lead, Design Basis & Modelling",
        "company": "Vestas Wind Systems A/S",
        "location": "Aarhus, Denmark",
        "desc": (
            "Led the team responsible for design basis, probabilistic design, and wind turbine dynamic "
            "modelling. Secretary of IEC PT 61400-9. Contributor to IECRE/TC88 Joint Working Forum on "
            "Model Validation. 4 patents filed during this period."
        ),
    },
    {
        "period": "Sep 2017 – Jan 2021",
        "role": "Lead Engineer — Loads & Controls Technologies",
        "company": "Vestas Wind Systems A/S",
        "location": "Aarhus, Denmark",
        "desc": (
            "Technical lead for probabilistic and reliability-based load calculations. Developed new tooling "
            "for reliability-based design. Led root cause analysis of aeroelastic modelling inaccuracies. "
            "Delivered load verification campaigns for type certification."
        ),
    },
    {
        "period": "Aug 2014 – Aug 2017",
        "role": "Senior Analyst — Loads & Controls",
        "company": "WEG Equipamentos Elétricos S.A.",
        "location": "Jaraguá do Sul, Brazil",
        "desc": (
            "First full-time loads and controls engineer at a Brazilian wind turbine OEM. Built the team's "
            "methodology and toolchain. Achieved 50% reduction in simulation processing time; 10× speedup "
            "via horizontal computing cluster. Supported multi-megawatt platform type certification."
        ),
    },
    {
        "period": "Nov 2010 – Jun 2014",
        "role": "Wind Engineer — Resource Assessment",
        "company": "Camargo Schubert Engenharia Eólica",
        "location": "Curitiba, Brazil",
        "desc": (
            "Wind resource assessment, meso/micro-scale flow modelling, blade aerodynamic design (BEM). "
            "Co-authored the Atlas Eólico da Bahia (2013), mapping 195 GW of wind potential. Automated "
            "reporting workflows — 60% reduction in production time."
        ),
    },
]

PATENTS = [
    {
        "title": "Design of a Wind Turbine Rotor Blade",
        "numbers": "EP4180653 · US11821402",
        "desc": "Reliability-based differentiation of gravity and wind fatigue safety factors to reduce blade material requirements.",
        "url": "https://patents.google.com/patent/EP4180653C0/en",
    },
    {
        "title": "Turbine Alignment by Use of Light Polarising Compass",
        "numbers": "EP3987176 · WO2020253925",
        "desc": "Compass-free turbine orientation estimation via sky polarisation. Sole inventor.",
        "url": "https://patents.google.com/patent/EP3987176A1/en",
    },
    {
        "title": "Blade Monitoring Through Active Promotion of Blade Vibrations",
        "numbers": "EP4146936 · US12331722",
        "desc": "Non-intrusive structural health monitoring by actively exciting blade natural frequencies.",
        "url": "https://patents.google.com/patent/EP4146936C0/en",
    },
    {
        "title": "Reduction of Edgewise Vibrations Using Blade Load Signal",
        "numbers": "EP4274960 · US12173694",
        "desc": "Active pitch-based damping of edgewise blade vibrations using measured load signals.",
        "url": "https://patents.google.com/patent/US20240068443A1/en",
    },
    {
        "title": "Individual Pitch Control with Unavailable Blade Load Sensor",
        "numbers": "EP4341553 · WO2022242816",
        "desc": "Fault-tolerant individual pitch control — maintains load reduction when one blade sensor fails.",
        "url": "https://patents.google.com/patent/ES3062808T3/en",
    },
    {
        "title": "Determination of Uncertainty of an Aeroelastic Model",
        "numbers": "EP4538922",
        "desc": "Model-form uncertainty quantification enabling certification without prototype testing.",
        "url": "https://patents.google.com/patent/EP4538922A1/en",
    },
]

PUBLICATIONS = [
    {
        "year": "2025",
        "text": "IEC TS 61400-9:2025 — Probabilistic Design Measures for Wind Turbines. IEC TC88.",
        "role": "Secretary, Project Team PT 61400-9",
        "url": "",
    },
    {
        "year": "2021–2024",
        "text": "IECRE/TC88 Joint Working Forum on Model Validation.",
        "role": "Contributor, alignment documents for the forthcoming IEC standard on aeroelastic model validation",
        "url": "https://etech.iec.ch/issue/2024-03/pioneering-model-validation-for-wind-turbines",
    },
    {
        "year": "2023",
        "text": 'J. Sønderkær Nielsen, H. S. Toft, G. O. Violato. "Risk-Based Assessment of the Reliability Level for Extreme Limit States in IEC 61400-1." Energies 16(4):1885.',
        "role": "",
        "url": "https://doi.org/10.3390/en16041885",
    },
    {
        "year": "2013",
        "text": "Atlas Eólico da Bahia. Camargo Schubert / SECTI / SENAI CIMATEC.",
        "role": "Co-author. Wind potential mapping for the state of Bahia, Brazil (195 GW identified at 150 m).",
        "url": "",
    },
]

DEMOS = [
    {
        "title": "HVAC & Solar Financial Simulator",
        "desc": (
            "Interactive financial model for evaluating HVAC system upgrades combined with solar panel "
            "installation under Danish energy pricing conditions."
        ),
        "url": "./hvac-sim/index.html",
        "tech": "JavaScript · Financial modelling",
    },
    {
        "title": "Wind Vane Magnetic Declination Tool",
        "desc": (
            "Browser-based tool for computing magnetic declination corrections for wind vane measurements, "
            "using the World Magnetic Model (WMM)."
        ),
        "url": "./vaned3/calcoffset.html",
        "tech": "D3.js · Geomagnetic model",
    },
]
