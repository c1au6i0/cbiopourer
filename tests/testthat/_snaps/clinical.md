# clinical sample tabs

    Code
      expected_meta_clinical_sample
    Output
        cancer_study_identifier..ptcls_example_2023
      1           genetic_alteration_type: CLINICAL
      2                datatype:  SAMPLE_ATTRIBUTES
      3     data_filename: data_clinical_sample.txt

---

    Code
      expected_data_clinical_sample
    Output
          X.Sample.ID Patient.ID Cancer.Type       Cancer.Type.Detailed    Cellline
      1    #sample id patient id cancer type       cancer type detailed cellline id
      2       #STRING     STRING      STRING                     STRING      STRING
      3            #1          1           1                          1           1
      4     SAMPLE_ID PATIENT_ID CANCER_TYPE       CANCER_TYPE_DETAILED    CELLLINE
      5     A_48h_VEH          A    Lymphoma Peripheral T-cell Lymphoma           A
      6     A_48h_VEH          A    Lymphoma Peripheral T-cell Lymphoma           A
      7  A_48h_DRUG_A          A    Lymphoma Peripheral T-cell Lymphoma           A
      8  A_48h_DRUG_A          A    Lymphoma Peripheral T-cell Lymphoma           A
      9  A_48h_DRUG_B          A    Lymphoma Peripheral T-cell Lymphoma           A
      10 A_48h_DRUG_B          A    Lymphoma Peripheral T-cell Lymphoma           A
      11    B_48h_VEH          B    Lymphoma Peripheral T-cell Lymphoma           B
      12    B_48h_VEH          B    Lymphoma Peripheral T-cell Lymphoma           B
      13 B_48h_DRUG_A          B    Lymphoma Peripheral T-cell Lymphoma           B
      14 B_48h_DRUG_A          B    Lymphoma Peripheral T-cell Lymphoma           B
      15    C_48h_VEH          C    Lymphoma Peripheral T-cell Lymphoma           C
      16    C_48h_VEH          C    Lymphoma Peripheral T-cell Lymphoma           C
      17 C_48h_DRUG_A          C    Lymphoma Peripheral T-cell Lymphoma           C
      18 C_48h_DRUG_A          C    Lymphoma Peripheral T-cell Lymphoma           C
      19    D_48h_VEH          D    Lymphoma Peripheral T-cell Lymphoma           D
      20    D_48h_VEH          D    Lymphoma Peripheral T-cell Lymphoma           D
      21 D_48h_DRUG_A          D    Lymphoma Peripheral T-cell Lymphoma           D
      22 D_48h_DRUG_A          D    Lymphoma Peripheral T-cell Lymphoma           D
      23    E_48h_VEH          E    Lymphoma Peripheral T-cell Lymphoma           E
      24    E_48h_VEH          E    Lymphoma Peripheral T-cell Lymphoma           E
      25 E_48h_DRUG_A          E    Lymphoma Peripheral T-cell Lymphoma           E
      26 E_48h_DRUG_A          E    Lymphoma Peripheral T-cell Lymphoma           E
      27 E_48h_DRUG_B          E    Lymphoma Peripheral T-cell Lymphoma           E
      28 E_48h_DRUG_B          E    Lymphoma Peripheral T-cell Lymphoma           E
      29    F_48h_VEH          F    Lymphoma Peripheral T-cell Lymphoma           F
      30    F_48h_VEH          F    Lymphoma Peripheral T-cell Lymphoma           F
      31 F_48h_DRUG_A          F    Lymphoma Peripheral T-cell Lymphoma           F
      32 F_48h_DRUG_A          F    Lymphoma Peripheral T-cell Lymphoma           F
                                  Time.Treat        Treatment
      1  time of administration of treatment drug admnistered
      2                               STRING           STRING
      3                                    1                1
      4                           TIME_TREAT            TREAT
      5                                  48h              VEH
      6                                  48h              VEH
      7                                  48h           DRUG_A
      8                                  48h           DRUG_A
      9                                  48h           DRUG_B
      10                                 48h           DRUG_B
      11                                 48h              VEH
      12                                 48h              VEH
      13                                 48h           DRUG_A
      14                                 48h           DRUG_A
      15                                 48h              VEH
      16                                 48h              VEH
      17                                 48h           DRUG_A
      18                                 48h           DRUG_A
      19                                 48h              VEH
      20                                 48h              VEH
      21                                 48h           DRUG_A
      22                                 48h           DRUG_A
      23                                 48h              VEH
      24                                 48h              VEH
      25                                 48h           DRUG_A
      26                                 48h           DRUG_A
      27                                 48h           DRUG_B
      28                                 48h           DRUG_B
      29                                 48h              VEH
      30                                 48h              VEH
      31                                 48h           DRUG_A
      32                                 48h           DRUG_A

# clinical patient tabs

    Code
      expected_meta_clinical_patient
    Output
                                                 V1
      1 cancer_study_identifier: ptcls_example_2023
      2           genetic_alteration_type: CLINICAL
      3               datatype:  PATIENT_ATTRIBUTES
      4    data_filename: data_clinical_patient.txt

---

    Code
      expected_data_clinical_patient
    Output
                  V1          V2
      1  #Patient ID    Cellline
      2  #patient id cellline id
      3      #STRING      STRING
      4           #1           1
      5   PATIENT_ID    CELLLINE
      6            A           A
      7            A           A
      8            A           A
      9            A           A
      10           A           A
      11           A           A
      12           B           B
      13           B           B
      14           B           B
      15           B           B
      16           C           C
      17           C           C
      18           C           C
      19           C           C
      20           D           D
      21           D           D
      22           D           D
      23           D           D
      24           E           E
      25           E           E
      26           E           E
      27           E           E
      28           E           E
      29           E           E
      30           F           F
      31           F           F
      32           F           F
      33           F           F

