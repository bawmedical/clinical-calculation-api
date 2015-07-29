module QRisk extend self

def eval options = {}
  begin
    #initialize
    options = QRisk.OPTIONS.merge options
    @errors = QRisk.ERRORS
    to_i = QRisk.method :to_i

    #assign attributes
    @age = options[:age]
    @age_centering = QRisk.AGE_CENTERING
    @age_continuous = QRisk.AGE_CONTINUOUS
    @age_polynomial = QRisk.AGE_POLYNOMIAL
    @age_range = QRisk.AGE_RANGE
    @atrial_fibrillation_dependent = QRisk.ATRIAL_FIBRILLATION_DEPENDENT
    @atrial_fibrillation_independent = QRisk.ATRIAL_FIBRILLATION_INDEPENDENT
    @blood_pressure = options[:blood_pressure]
    @blood_pressure_centering = QRisk.BLOOD_PRESSURE_CENTERING
    @blood_pressure_continuous = QRisk.BLOOD_PRESSURE_CONTINUOUS
    @blood_pressure_dependent = QRisk.BLOOD_PRESSURE_DEPENDENT
    @blood_pressure_range = QRisk.BLOOD_PRESSURE_RANGE
    @blood_pressure_treatment_independent = QRisk.BLOOD_PRESSURE_TREATMENT_INDEPENDENT
    @blood_pressure_treatment_dependent = QRisk.BLOOD_PRESSURE_TREATMENT_DEPENDENT
    @bmi = options[:body_mass_index]
    @bmi_centering = QRisk.BMI_CENTERING
    @bmi_continuous = QRisk.BMI_CONTINUOUS
    @bmi_dependent = QRisk.BMI_DEPENDENT
    @bmi_polynomial = QRisk.BMI_POLYNOMIAL
    @bmi_range = QRisk.BMI_RANGE
    @cholesterol_ratio = options[:cholesterol_ratio]
    @cholesterol_ratio_centering = QRisk.CHOLESTEROL_RATIO_CENTERING
    @cholesterol_ratio_continuous = QRisk.CHOLESTEROL_RATIO_CONTINUOUS
    @cholesterol_ratio_range = QRisk.CHOLESTEROL_RATIO_RANGE
    @decade_odds = QRisk.DECADE_ODDS
    @diabetes = options[:diabetes].to_sym
    @diabetes_dependent = QRisk.DIABETES_DEPENDENT
    @diabetes_independent = QRisk.DIABETES_INDEPENDENT
    @diabetes_ratio_range = QRisk.CHOLESTEROL_RATIO_RANGE
    @diabetes_types = QRisk.DIABETES_TYPES
    @ethnicity = options[:ethnicity].to_sym
    @ethnicity_risk = QRisk.ETHNICITY_RISK
    @ethnicity_types = QRisk.ETHNICITY_TYPES
    @gender = options[:gender].to_sym
    @genders = QRisk.GENDERS
    @heart_diseased_relative_dependent = QRisk.HEART_DISEASED_RELATIVE_DEPENDENT
    @heart_diseased_relative_independent = QRisk.HEART_DISEASED_RELATIVE_INDEPENDENT
    @kidney_disease_dependent = QRisk.KIDNEY_DISEASE_DEPENDENT
    @kidney_disease_independent = QRisk.KIDNEY_DISEASE_INDEPENDENT
    @rheumatoid_arthritis_independent = QRisk.RHEUMATIOD_ARTHRITIS_INDEPENDENT
    @smoker = options[:smoker].to_sym
    @smoker_dependent = QRisk.SMOKER_DEPENDENT
    @smoker_independent = QRisk.SMOKER_INDEPENDENT
    @smoker_types = QRisk.SMOKER_TYPES

    @debug = options[:internal_debug]

    #validate
    raise @errors[:age] unless @age_range.include? @age or @age == 0
    raise @errors[:blood_pressure] unless @blood_pressure_range.include? @blood_pressure or @blood_pressure == 0
    raise @errors[:bmi] unless @bmi_range.include? @bmi or @bmi == 0
    raise @errors[:cholesterol_ratio] unless @cholesterol_ratio_range.include? @cholesterol_ratio or @cholesterol_ratio == 0
    raise @errors[:diabetes] unless @diabetes_types.include? @diabetes
    raise @errors[:ethnicity] unless @ethnicity_types.include? @ethnicity
    raise @errors[:gender] unless @genders.include? @gender
    raise @errors[:smoker] unless @smoker_types.include? @smoker

    #scale these "constants"
    @age *= QRisk.AGE_SCALE
    @bmi *= QRisk.BMI_SCALE

    #ranged constants
    @age_upper = @age.zero? ? 0 : @age ** @age_polynomial[@gender][:age_upper] - @age_centering[@gender][:age_upper]
    @age_lower = @age.zero? ? 0 : @age ** @age_polynomial[@gender][:age_lower] - @age_centering[@gender][:age_lower]
    @bmi_upper = @bmi.zero? ? 0 : @bmi ** @bmi_polynomial - @bmi_centering[@gender][:bmi_upper]
    @bmi_lower = @bmi.zero? ? 0 : @bmi ** @bmi_polynomial * Math.log(@bmi) - @bmi_centering[@gender][:bmi_lower]
    @blood_pressure_center    = @blood_pressure    - @blood_pressure_centering    [@gender]
    @cholesterol_ratio_center = @cholesterol_ratio - @cholesterol_ratio_centering [@gender]

    printf "a1: %6.2f, a2: %6.2f\n", @age_upper, @age_lower if @debug
    printf "b1: %6.2f, b2: %6.2f\n", @bmi_upper, @bmi_lower if @debug
    printf "cr: %6.2f, bp: %6.2f\n", @cholesterol_ratio_center * @cholesterol_ratio_continuous [@gender],
                                     @blood_pressure_center    * @blood_pressure_continuous    [@gender] if @debug

    #evaluate booleans
    @heart_diseased_relative  = to_i options[:heart_diseased_relative]
    @kidney_disease           = to_i options[:kidney_disease]
    @atrial_fibrillation      = to_i options[:atrial_fibrillation]
    @blood_pressure_treatment = to_i options[:blood_pressure_treatment]
    @rheumatoid_arthritis     = to_i options[:rheumatoid_arthritis]

    printf "af:%5.2f, ra:%5.2f, rn:%5.2f, tr:%5.2f, rl:%5.2f, db:%5.2f\n",
      @atrial_fibrillation                   * @atrial_fibrillation_independent      [@gender],
      @rheumatoid_arthritis                  * @rheumatoid_arthritis_independent     [@gender],
      @kidney_disease                        * @kidney_disease_independent           [@gender],
      @blood_pressure_treatment              * @blood_pressure_treatment_independent [@gender],
      @heart_diseased_relative               * @heart_diseased_relative_independent  [@gender],
      @diabetes_independent                   [@gender][@diabetes] if @debug

    printf "i:%6.2f u:%6.2f l:%6.2f er:%6.2f\n",
      @ethnicity_risk                         [@gender][@ethnicity]                                           +
      @smoker_independent                     [@gender][@smoker]                                              +
      @diabetes_independent                   [@gender][@diabetes]                                            +
      @bmi_upper                             * @bmi_continuous                       [@gender][:bmi_upper]    +
      @bmi_lower                             * @bmi_continuous                       [@gender][:bmi_lower]    +
      @heart_diseased_relative               * @heart_diseased_relative_independent  [@gender]                +
      @kidney_disease                        * @kidney_disease_independent           [@gender]                +
      @atrial_fibrillation                   * @atrial_fibrillation_independent      [@gender]                +
      @blood_pressure_treatment              * @blood_pressure_treatment_independent [@gender]                +
      @rheumatoid_arthritis                  * @rheumatoid_arthritis_independent     [@gender],

      #age spread dependent risks
      @age_upper * @heart_diseased_relative  * @heart_diseased_relative_dependent    [@gender][:age_upper]    +
      @age_upper * @kidney_disease           * @kidney_disease_dependent             [@gender][:age_upper]    +
      @age_upper * @atrial_fibrillation      * @atrial_fibrillation_dependent        [@gender][:age_upper]    +
      @age_upper * @blood_pressure_treatment * @blood_pressure_treatment_dependent   [@gender][:age_upper]    +
      @age_upper * @smoker_dependent          [@gender][:age_upper][@smoker]                                  +
      @age_upper * @diabetes_dependent        [@gender][:age_upper][@diabetes]                                +
      @age_upper * @bmi_upper * @bmi_dependent             [@gender][:age_upper][:bmi_upper]                  +
      @age_upper * @bmi_lower * @bmi_dependent             [@gender][:age_upper][:bmi_lower]                  +
      @age_upper * @blood_pressure_center * @blood_pressure_dependent  [@gender][:age_upper],

      @age_lower * @heart_diseased_relative  * @heart_diseased_relative_dependent    [@gender][:age_lower]    +
      @age_lower * @kidney_disease           * @kidney_disease_dependent             [@gender][:age_lower]    +
      @age_lower * @atrial_fibrillation      * @atrial_fibrillation_dependent        [@gender][:age_lower]    +
      @age_lower * @blood_pressure_treatment * @blood_pressure_treatment_dependent   [@gender][:age_lower]    +
      @age_lower * @smoker_dependent          [@gender][:age_lower][@smoker]                                  +
      @age_lower * @diabetes_dependent        [@gender][:age_lower][@diabetes]                                +
      @age_lower * @bmi_upper * @bmi_dependent             [@gender][:age_lower][:bmi_upper]                  +
      @age_lower * @bmi_lower * @bmi_dependent             [@gender][:age_lower][:bmi_lower]                  +
      @age_lower * @blood_pressure_center * @blood_pressure_dependent  [@gender][:age_lower],

      @ethnicity_risk[@gender][@ethnicity] if @debug

    printf "bp:%6.2f bu:%6.2f bl:%6.2f\n",
      @blood_pressure_center,
      @age_upper * @blood_pressure_center * @blood_pressure_dependent[@gender][:age_upper],
      @age_lower * @blood_pressure_center * @blood_pressure_dependent[@gender][:age_lower] if @debug

  rescue => exception
    abort "\033[31merror: " + exception.message + "\033[0m"
  else
    #calculate
    options.to_s + " => "
    "%.6f" % (
      100 * (1 - @decade_odds[@gender] ** Math.exp(
        #age spread independent risks
        @ethnicity_risk                         [@gender][@ethnicity]                                           +
        @smoker_independent                     [@gender][@smoker]                                              +
        @diabetes_independent                   [@gender][@diabetes]                                            +
        @cholesterol_ratio_center              * @cholesterol_ratio_continuous         [@gender]                +
        @blood_pressure_center                 * @blood_pressure_continuous            [@gender]                +
        @bmi_upper                             * @bmi_continuous                       [@gender][:bmi_upper]    +
        @bmi_lower                             * @bmi_continuous                       [@gender][:bmi_lower]    +
        @heart_diseased_relative               * @heart_diseased_relative_independent  [@gender]                +
        @kidney_disease                        * @kidney_disease_independent           [@gender]                +
        @atrial_fibrillation                   * @atrial_fibrillation_independent      [@gender]                +
        @blood_pressure_treatment              * @blood_pressure_treatment_independent [@gender]                +
        @rheumatoid_arthritis                  * @rheumatoid_arthritis_independent     [@gender]                +

        #age spread dependent risks
        @age_upper                             * @age_continuous                       [@gender][:age_upper]    +
        @age_upper * @heart_diseased_relative  * @heart_diseased_relative_dependent    [@gender][:age_upper]    +
        @age_upper * @kidney_disease           * @kidney_disease_dependent             [@gender][:age_upper]    +
        @age_upper * @atrial_fibrillation      * @atrial_fibrillation_dependent        [@gender][:age_upper]    +
        @age_upper * @blood_pressure_treatment * @blood_pressure_treatment_dependent   [@gender][:age_upper]    +
        @age_upper * @smoker_dependent          [@gender][:age_upper][@smoker]                                  +
        @age_upper * @diabetes_dependent        [@gender][:age_upper][@diabetes]                                +
        @age_upper * @bmi_upper * @bmi_dependent             [@gender][:age_upper][:bmi_upper]                  +
        @age_upper * @bmi_lower * @bmi_dependent             [@gender][:age_upper][:bmi_lower]                  +
        @age_upper * @blood_pressure_center * @blood_pressure_dependent  [@gender][:age_upper]                  +

        @age_lower                             * @age_continuous                       [@gender][:age_lower]    +
        @age_lower * @heart_diseased_relative  * @heart_diseased_relative_dependent    [@gender][:age_lower]    +
        @age_lower * @kidney_disease           * @kidney_disease_dependent             [@gender][:age_lower]    +
        @age_lower * @atrial_fibrillation      * @atrial_fibrillation_dependent        [@gender][:age_lower]    +
        @age_lower * @blood_pressure_treatment * @blood_pressure_treatment_dependent   [@gender][:age_lower]    +
        @age_lower * @smoker_dependent          [@gender][:age_lower][@smoker]                                  +
        @age_lower * @diabetes_dependent        [@gender][:age_lower][@diabetes]                                +
        @age_lower * @bmi_upper * @bmi_dependent             [@gender][:age_lower][:bmi_upper]                  +
        @age_lower * @bmi_lower * @bmi_dependent             [@gender][:age_lower][:bmi_lower]                  +
        @age_lower * @blood_pressure_center * @blood_pressure_dependent  [@gender][:age_lower]
      ))
    )
  end
end

def help
  "QRisk display help info..."
end

protected

$, = ", " #default join

def OPTIONS;{ #default options
  gender:                  :male,
  age:                      0,
  body_mass_index:          0,
  smoker:                  :non,
  diabetes:                :none,
  ethnicity:               :white,
  heart_diseased_relative:  false,
  kidney_disease:           false,
  atrial_fibrillation:      false,
  blood_pressure_treatment: false,
  rheumatoid_arthritis:     false,
  cholesterol_ratio:        3.7,
  blood_pressure:           0.0
};end

def ERRORS;{
  age:              "age must be in range: " + QRisk.AGE_RANGE.to_s,
  blood_pressure:   "blood pressure must be in range: " + QRisk.BLOOD_PRESSURE_RANGE.to_s,
  bmi:              "bmi must be in range: " + QRisk.BMI_RANGE.to_s,
  cholesterol_ratio:"cholesterol ratio must be in range: " + QRisk.CHOLESTEROL_RATIO_RANGE.to_s,
  diabetes:         "invalid diabetes type, options: " + QRisk.DIABETES_TYPES.join,
  ethnicity:        "invalid ethnicity type, options: " + QRisk.ETHNICITY_TYPES.join,
  gender:           "invalid gender, options: " + QRisk.GENDERS.join,
  smoker:           "invalid smoker type, options: " + QRisk.SMOKER_TYPES.join
};end

def DIABETES_TYPES;[
  :none,
  :type_1,
  :type_2
];end

def ETHNICITY_TYPES;[
  :white,
  :indian,
  :pakistani,
  :bangladeshi,
  :other_asian,
  :black_caribbean,
  :black_african,
  :chinese,
  :other
];end

def GENDERS;[
  :male,
  :female
];end

def SMOKER_TYPES;[
  :non,
  :ex,
  :light,
  :moderate,
  :heavy
];end

def AGE_SCALE;            0.1; end

def AGE_CONTINUOUS;{
  male:{
    age_upper:          -19.4666173334122840000000000,
    age_lower:            0.0201364267507625730000000
  },
  female:{
    age_upper:            4.1924277678057837000000000,
    age_lower:            0.0727365264473135150000000
  }
};end

def AGE_POLYNOMIAL;{
  male:{
    age_upper:           -1,
    age_lower:            2
  },
  female:{
    age_upper:            0.5,
    age_lower:            1
  }
};end

def AGE_CENTERING;{
  male:{
    age_upper:            0.229260012507439,
    age_lower:           19.025821685791016
  },
  female:{
    age_upper:            2.111304044723511,
    age_lower:            4.457604408264160
  }
};end

def AGE_RANGE; (25..84); end

def ATRIAL_FIBRILLATION_INDEPENDENT;{
  male:                   0.8561770660317954400000000,
  female:                 1.2548823570386274000000000
};end

def ATRIAL_FIBRILLATION_DEPENDENT;{
  male:{
    age_upper:            6.8279483425030065000000000,
    age_lower:            0.0051545540015502968000000
  },
  female:{
    age_upper:           -2.0489636167088636000000000,
    age_lower:            0.1989800041198926100000000
  }
};end

def BLOOD_PRESSURE_CENTERING;{
  male:                 131.575469970703120,
  female:               126.525978088378910
};end

def BLOOD_PRESSURE_CONTINUOUS;{
  male:                   0.0099543428482831708000000,
  female:                 0.0124301977948376370000000
};end

def BLOOD_PRESSURE_DEPENDENT;{
  male:{
    age_upper:            0.0328765577798371750000000,
    age_lower:           -0.0001231469495691592500000
  },
  female:{
    age_upper:            0.0035841283715529319000000,
    age_lower:           -0.0037836254753488216000000
  }
};end

def BLOOD_PRESSURE_TREATMENT_INDEPENDENT;{
  male:                   0.6570994445804946300000000,
  female:                 0.6183822524814552900000000
};end

def BLOOD_PRESSURE_TREATMENT_DEPENDENT;{
  male:{
    age_upper:            6.8793023059229004000000000,
    age_lower:            0.0042514995185120022000000
  },
  female:{
    age_upper:           -3.9467205554873872000000000,
    age_lower:            0.6659359807539360100000000
  }
};end

def BLOOD_PRESSURE_RANGE; (70..210); end


def BMI_SCALE;            0.1; end

def BMI_POLYNOMIAL;      -2; end

def BMI_CENTERING;{
  male:{
    bmi_upper:            0.146091341972351,
    bmi_lower:            0.140505045652390
  },
  female:{
    bmi_upper:            0.153318107128143,
    bmi_lower:            0.143754154443741
  }
};end

def BMI_CONTINUOUS;{
  male:{
    bmi_upper:            1.3830867611940247000000000,
    bmi_lower:           -7.1627340311445842000000000
  },
  female:{
    bmi_upper:           -0.4914322358663353900000000,
    bmi_lower:           -2.9736893891126503000000000
  }
};end

def BMI_DEPENDENT;{
  male:{
    age_upper:{
      bmi_upper:         46.1982485629838000000000000,
      bmi_lower:       -169.4442164713507000000000000
    },
    age_lower:{
      bmi_upper:          0.1174445082068387000000000,
      bmi_lower:         -0.3493064079001478300000000
    }
  },
  female:{
    age_upper:{
      bmi_upper:         15.6869018580842020000000000,
      bmi_lower:         10.5172051502483440000000000
    },
    age_lower:{
      bmi_upper:         -3.0654336861574962000000000,
      bmi_lower:         -1.0265341871793443000000000
    }
  }
};end

def BMI_RANGE; (20..40); end

def CHOLESTEROL_RATIO_CENTERING;{
  male:                   4.400725841522217,
  female:                 3.597785472869873
};end

def CHOLESTEROL_RATIO_CONTINUOUS;{
  male:                   0.1533097330217813300000000,
  female:                 0.1456741893144524700000000
};end

def CHOLESTEROL_RATIO_RANGE; (1..12); end

def DECADE_ODDS;{
  male:                   0.978206992149353,
  female:                 0.988779306411743
};end

def DIABETES_DEPENDENT;{
  male:{
    age_upper:{
      none:               0,
      type_1:             2.5566900730730104000000000,
      type_2:             2.5043645216873411000000000
    },
    age_lower:{
      none:               0,
      type_1:            -0.0029641180896136064000000,
      type_2:            -0.0049052623533052224000000
    }
  },
  female:{
    age_upper:{
      none:               0,
      type_1:             5.0295952006040174000000000,
      type_2:            -4.1006039491910871000000000
    },
    age_lower:{
      none:               0,
      type_1:            -1.3790306447153591000000000,
      type_2:             0.6477002677213917800000000
    }
  }
};end

def DIABETES_INDEPENDENT;{
  male:{
    none:                 0,
    type_1:               1.2235901893205057000000000,
    type_2:               0.8201160328780074900000000
  },
  female:{
    none:                 0,
    type_1:               1.7623106103850039000000000,
    type_2:               1.0714795465634313000000000
  }
};end

def ETHNICITY_RISK;{
  male:{
    white:                0,
    indian:               0.2455190496467173600000000,
    pakistani:            0.5660101891908698700000000,
    bangladeshi:          0.5071774786941407600000000,
    other_asian:          0.1389394355409972500000000,
    black_caribbean:     -0.3741460040971635900000000,
    black_african:       -0.4569877668572746000000000,
    chinese:             -0.3980300277796868800000000,
    other:               -0.2458314247118184900000000
  },
  female:{
    white:                0,
    indian:               0.3247649848349589700000000,
    pakistani:            0.6490919016600146300000000,
    bangladeshi:          0.3225960666395069100000000,
    other_asian:         -0.0698843828816220060000000,
    black_caribbean:     -0.0526174237973003890000000,
    black_african:       -0.3583620628676293400000000,
    chinese:             -0.4631969844038496000000000,
    other:               -0.0934620942542618430000000
  }
};end

def KIDNEY_DISEASE_INDEPENDENT;{
  male:                   0.7661782832063270800000000,
  female:                 0.8000369779764396900000000
};end

def KIDNEY_DISEASE_DEPENDENT;{
  male:{
    age_upper:           -1.2499862850572443000000000,
    age_lower:           -0.0190484751944149380000000
  },
  female:{
    age_upper:            2.1378812069259072000000000,
    age_lower:           -0.5666471358116902400000000
  }
};end

def HEART_DISEASED_RELATIVE_INDEPENDENT;{
  male:                   0.6962022338056947900000000,
  female:                 0.6138914873273221300000000
};end

def HEART_DISEASED_RELATIVE_DEPENDENT;{
  male:{
    age_upper:            2.5891954185540058000000000,
    age_lower:           -0.0059689380584026352000000
  },
  female:{
    age_upper:            0.1788021490217178200000000,
    age_lower:           -0.1598294041246048900000000
  }
};end

def RHEUMATIOD_ARTHRITIS_INDEPENDENT;{
  male:                   0.3295853885133138700000000,
  female:                 0.3660166445401525400000000
};end

def SMOKER_INDEPENDENT;{
  male:{
    non:                  0,
    ex:                   0.2733747359324866800000000,
    light:                0.5613178495903169400000000,
    moderate:             0.6862483380221766600000000,
    heavy:                0.8089648612880009400000000
  },
  female:{
    non:                  0,
    ex:                   0.2325777856801529700000000,
    light:                0.5540189636820945800000000,
    moderate:             0.6903408593375299800000000,
    heavy:                0.8853278749891940700000000
  }
};end

def SMOKER_DEPENDENT;{
  male:{
    age_upper:{
      non:                0,
      ex:                 0.7675246688050250100000000,
      light:              0.7287918369962067500000000,
      moderate:           3.2938032311654148000000000,
      heavy:              3.6962686629926185000000000
    },
    age_lower:{
      non:                0,
      ex:                -0.0028190973036285923000000,
      light:             -0.0074290549312194289000000,
      moderate:           0.0006623943592407952700000,
      heavy:             -0.0009539165087934006100000
    }
  },
  female:{
    age_upper:{
      non:                0,
      ex:                 1.5288149154981097000000000,
      light:              1.8932677924373249000000000,
      moderate:          -0.2120377720167573300000000,
      heavy:             -1.8022626575074350000000000
    },
    age_lower:{
      non:                0,
      ex:                -0.3515526357562532800000000,
      light:             -0.4673806143887411200000000,
      moderate:          -0.0520627514443069360000000,
      heavy:              0.2408148624618006200000000
    }
  }
};end

def to_i value
  (value.eql? true or value.to_s == "true" or (
    value.to_f != 0 if value.respond_to? 'to_f'
  )) ? 1 : 0
end

end

puts QRisk.eval eval(ARGV[0].to_s) if ARGV.length !=0