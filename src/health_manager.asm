.MODEL SMALL 
print_appropriate_weight MACRO
    MOV BL, 100
    DIV BL    
    MOV DH, AH
    ;digit1
    ADD AL, 48
    MOV DL, AL
    MOV AH, 2
    INT 21H
    ;digit2
    MOV AL, DH
    MOV AH, 0
    MOV BL, 10
    DIV BL
    MOV DH, AH
    MOV DL, AL
    ADD DL, 48
    MOV AH, 2
    INT 21H 
    ;digit3
    MOV DL, DH
    ADD DL, 48
    MOV AH, 2
    INT 21H
ENDM     

print_payment_amount MACRO AX
    ;digit1
    MOV DX, 0
    MOV BX, 1000
    DIV BX ;DX:AX/BX->DX(remainder), AX(quotient)
    MOV CX, DX ;CX has remainder
    MOV DL, AL
    ADD DL, 48
    MOV AH, 2
    INT 21H
    ;digit2
    MOV AX, CX
    MOV BL, 100
    DIV BL  
    MOV CL, AH ;CL has remainder
    MOV DL, AL
    ADD DL, 48
    MOV AH, 2
    INT 21H
    ;digit3 
    MOV CH, 0
    MOV AX, CX
    MOV BL, 10
    DIV BL
    MOV CL, AH ;CL has remainder
    MOV DL, AL
    ADD DL, 48
    MOV AH, 2
    INT 21H      
    ;digit4
    MOV DL, CL
    ADD DL, 48
    MOV AH, 2
    INT 21H
ENDM

appointment_counter MACRO
    MOV AL, chosen_doctor
    MOV AH, 0
    DEC AX ;doctor1 at 0th index
    MOV SI, AX
    MOV BL, doctor_level_array[SI]  
    CMP BL, 0
    JLE no_available_slot
    DEC BL
    MOV doctor_level_array[SI] , BL
ENDM      

calculate_advance MACRO fee, adv
    MOV AX, fee
    MOV BX, adv
    MOV CL, 100
    DIV CL ;fee/100 -> AL(quotient), AH(remainder=0)
    MUL BX ;result in DX(0):AX
    MOV payment, AX
ENDM
 
.STACK 100H

.DATA

; declare variables here   

;user input variables
user_name db 50 dup(?)
gender db ? ;F/M
age db 0            
weight db 0 ;in kg  
height db 0 ;in metre  
activity_level db 0
menu db 0

;gender full form
F_full db "Female$"
M_full db "Male$" 

;admin verify variable  
; admin=5 (Adminn name verified)
; admin=0 (initially not verified) 
admin db 0

;admin system password= "NaNdNm"
; admin_pass=6 (Admin pass verified)
; admin_pass=0 (initially not verified) 
admin_pass db 0

;admin flag
adminflag db 0  
             
             
activity_level_array db "Sedentary$","Lightly active$","Moderately active$","Very active$"

welcomeMsg    DB 13,10, "============ Welcome to HEALTH MANAGER ============",13,10,13,10,"$"    ;new day1 l
adloginMsg    DB 13,10, "======== Logged in as ADMIN ========",13,10,13,10,"$"    ;new day2 l
ad_not_veri   DB 13,10, "======== ADMIN verification UNSUCCESSFUL ========",13,10,13,10,"$"    ;new day2 l

;FR1: DIGITAL HEALTH BOOK       ;new day1 l

input_name            DB 13,10, "Enter your name           : $"
input_admin_pass      DB 13,10, "Enter your ADMIN password : $"
input_gender          DB 13,10, "Enter your gender (F/M)   : $"
input_age             DB 13,10, "Enter your age            : $"
input_weight          DB 13,10, "Enter your weight (Kg)    : $"
input_height          DB 13,10, "Enter your height (cm)    : $"  
input_actlvl          DB 13,10, "Choose your Activity Level: " ,13,10
                      DB 32,32, "1. Sedentary (little to no exercise)",13,10 
                      DB 32,32, "2. Lightly active (light exercise/sports 1-3 days/week)",13,10
                      DB 32,32, "3. Moderately active (moderate exercise/sports 3-5 days/week)",13,10
                      DB 32,32, "4. Very active (hard exercise/sports 6-7 days a week)",13,10
                      DB 13,10, "Enter your choice (1/2/3/4): $" 
                      
;health book info generating msg
FR1_Msg   DB 13,10, "==========(1) YOUR DIGITAL HEALTH BOOK =========== ",13,10,"$"
p_name    DB 13,10, "Patient's name           : $"
p_gender  DB 13,10, "Patient's gender         : $"
p_age     DB 13,10, "Patient's age            : $"
p_weight  DB 13,10, "Patient's weight (Kg)    : $"
p_height  DB 13,10, "Patient's height (cm)    : $"
p_actlvl  DB 13,10, "Patient's activity level : $" 
ending    DB 13,10, "================================================== ",13,10,13,10,"$"


;asking user in which menu he/she wants to go 
input_menu  DB 13,10, "=================== MENU BAR ===================== " ,13,10
            DB 32,32, "(2) BMI Calculator",13,10 
            DB 32,32, "(3) Diet Suggestion",13,10
            DB 32,32, "(4) Appointment booking and receipt generator",13,10
            DB 32,32, "(5) Exit System",13,10
            DB 13,10
            DB 13,10, "To explore our other features, choose (2/3/4/5): $" 



                      
;use_sys_again DB 13,10, "Want to use our system again (Y/N) : $"  

goodbyeMsg    DB 13,10, "    Thank you for using our system. Take care.  " ,13,10,"$"
                
start_newuser DB 13,10, "=================== WELCOME NEW USER ===================== " ,13,10
              DB 13,10, "To start using our system, press (1): $" 



;invalid input msg
gender_invalid        DB 13,10, "======== INVALID gender input ========",13,10,13,10,"$"    ;new day2 l


;variables for BMR
;input_height_cm DB 13,10, "Enter your height in cm  : $"
height_cm db 0
BMR dw 0
calory dw 0  

;activity factor
actlvl_1 dw 1200  ;Sedentary         = 1.2
actlvl_2 dw 1375  ;Lightly active    = 1.375
actlvl_3 dw 1550  ;Moderately active = 1.55
actlvl_4 dw 1725  ;Very active       = 1.725
                                                   
                                                   
;===FR3 MSGS==================================== 

FR3_Msg   DB 13,10, "=======================(3) DIET SUGGESTION ===================== ",13,10,"$"
tdee      DB 13,10, "To maintain your current weight, calories (Kcal/day) : $"
 
next_pg   DB 13,10, "GO TO NEXT PAGE FOR DIET SUGGESTION  (press 3) : $"
exit_diet DB 13,10, "TO EXIT DIET SUGGESTION   (press E) : $"

F_TEEN_UND  DB 13,10, "Goal: Gain healthy weight and support teenage growth. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"
            
F_TEEN_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruits or eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Brown rice / chapati + lean protein + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt or boiled eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Dinner	Lentils + whole wheat chapati + salad",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 55% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"
             
F_TEEN_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk + fruit",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Snack	Nuts (small portion)",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + vegetables, avoid rice/pasta",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40 - 50% of calories",13,10
            DB 13,10, " Fat    : 20 - 25% of calories",13,10,"$"

F_TEEN_OBS  DB 13,10, "Goal: Strong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 500 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Breakfast	Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Lunch	Grilled fish/chicken + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Boiled egg or small nuts portion",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$"
                                                                 
F_ADLT_UND  DB 13,10, "Goal: Gain healthy weight, increase muscle mass and energy. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"
                                                                 
F_ADLT_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + whole wheat chapati + salad",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"

F_ADLT_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"

F_ADLT_OBS  DB 13,10, "Goal: Strong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 500 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Lunch	Grilled fish/chicken + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Boiled egg or small nuts portion",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$" 

F_SNAD_UND  DB 13,10, "Goal: Gain healthy weight, increase muscle mass and energy. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice / chapati + chicken or lentils + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$" 

F_SNAD_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruits or eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"            
            
F_SNAD_OVR  DB 13,10, "Goal: Gain healthy weight and support teenage growth. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt or boiled eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat chapati + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 55% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"            
            

F_SNAD_OBS  DB 13,10, "Goal: Strong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 500 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk and vegetable omelet",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled fish and salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Boiled egg or small nut portion",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low fat soup",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$"            

F_SENR_UND  DB 13,10, "Goal: Gain healthy weight, increase muscle mass and energy. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 60% of calories",13,10
            DB 13,10, " Fat    : 20 - 30% of calories",13,10,"$"            

F_SENR_NOR  DB 13,10, "Goal: Maintain health and weigh. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruit + egg",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lean protein + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      lentils + whole chapati + salad",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"            

F_SENR_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 350 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk + fruit",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Nuts (small portion) ",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + vegetables, avoid rice/pasta",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40 - 50% of calories",13,10
            DB 13,10, " Fat    : 20 - 25% of calories",13,10,"$"            


F_SENR_OBS  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 500 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Nuts (small portion)",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$"            

;== MALE DIET SUGGESTION MSG======
M_TEEN_UND  DB 13,10, "Goal: Gain healthy weight and support teenage growth. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 450 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats +  milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2-3 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 60% of calories",13,10
            DB 13,10, " Fat    : 20 - 30% of calories",13,10,"$"
            
M_TEEN_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruits",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lean protein + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat chapati + lentils + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 55% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"
             
M_TEEN_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 400 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Nuts (small portion)",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + vegetables, avoid rice/pasta",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40 - 50% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"

M_TEEN_OBS  DB 13,10, "Goal: trong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 550 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled fish/chicken + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Boiled egg or small nuts portion",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$"
                                                                 
M_ADLT_UND  DB 13,10, "Goal: Gain healthy weight and support teenage growth. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 400 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + whole wheat chapati + salad",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"
                                                                 
M_ADLT_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruits or eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Brown rice / chapati + lean protein + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 55% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"

M_ADLT_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 400 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk + fruit",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Nuts (small portion)",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + vegetables, avoid rice/pasta",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 20 - 30% of calories",13,10,"$"

M_ADLT_OBS  DB 13,10, "Goal: Strong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 550 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled fish/chicken + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$" 

M_SNAD_UND  DB 13,10, "Goal: Gain healthy weight and support teenage growth. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 400 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 60% of calories",13,10
            DB 13,10, " Fat    : 20 - 30% of calories",13,10,"$" 

M_SNAD_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruits or eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Brown rice / chapati + lean protein + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + whole wheat chapati + salad",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 55% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"            
            
M_SNAD_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 400 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk + fruit",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + vegetables, avoid rice/pasta",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40 - 50% of calories",13,10
            DB 13,10, " Fat    : 20 - 25% of calories",13,10,"$"            
            

M_SNAD_OBS  DB 13,10, "Goal:  Strong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 550 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled fish/chicken + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Boiled egg or small nuts portion",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$"            

M_SENR_UND  DB 13,10, "Goal: Gain healthy weight and support teenage growth. " ,13,10
            DB 32,32, "Calorie Intake: TDEE + 450 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + full-fat milk + 2 eggs + banana",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Rice or chapati + lentils/chicken + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Whole wheat pasta + lean meat + cooked vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 55 - 60% of calories",13,10
            DB 13,10, " Fat    : 20 - 30% of calories",13,10,"$"            

M_SENR_NOR  DB 13,10, "Goal: Maintain weight and health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats + fruits or eggs",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Brown rice / chapati + lean protein + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Yogurt + honey or fruit smoothie",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + whole wheat chapati + salad",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 2 g/kg body weight",13,10
            DB 13,10, " Carbs  : 50 - 60% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"            

M_SENR_OVR  DB 13,10, "Goal: Lose weight safely, preserve muscle mass. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 450 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Oats with skim milk + fruit",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled chicken or fish + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Nuts (small portion)",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils + vegetables, avoid rice/pasta",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40 - 50% of calories",13,10
            DB 13,10, " Fat    : 25 - 30% of calories",13,10,"$"            


M_SENR_OBS  DB 13,10, "Goal: Strong calorie deficit, reduce fat, improve metabolic health. " ,13,10
            DB 32,32, "Calorie Intake: TDEE - 550 kcal",13,10 
            
            DB 13,10, " DIET SUGGESTION ======================================",13,10
            DB 13,10, " Meal	       Example Foods",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Breakfast   Vegetable omelet or oats with skim milk",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Lunch       Grilled fish/chicken + salad + 1 chapati",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Snack       Boiled egg or small nuts portion",13,10
            DB 13,10, " ----------------------------------------------------------------"
            DB 13,10, " Dinner      Lentils or low-fat soup + vegetables",13,10
            DB 13,10, " ----------------------------------------------------------------", 13,10
            
            DB 13,10, " Macro Guidance: ",13,10
            DB 13,10, " Protein: 1 g/kg body weight",13,10
            DB 13,10, " Carbs  : 40% of calories",13,10
            DB 13,10, " Fat    : 20% of calories",13,10,"$"            

            


;######################-----------NAHIAN---------###################messages
;BMI
BMI_msg                db 13,10,"==========(2) YOUR BMI DETAILS ==========="
                       db 13,10,"Your BMI is $"
BMIflag                db 0
underweight            db 13,10,"You are underweight $"
normal                 db 13,10,"Your weight is normal  $"
overweight             db 13,10,"You are overweight $"
obese                  db 13,10,"You are obese$" 
appropriate_weight_msg db 13,10,"Healthy weight range for you is between $"
a                      db " and $"
kgm2                   db "kg/m^2$"
kg                     db "kg$"  



;appointment array. can be reset by admin
doctor_level_array db 2 dup(3) ;each doctor can take 3 patients inially
;appointment 
doctor_details DB 13,10, 13,10, 'Doctor Details:======================================',13,10
               DB 13,10, 'Doctor ID 1-',13,10
               DB '   Name: Dr. Sultana Rabeya',13,10
               DB '   Designation: Professor',13,10
               DB '   Available time: 8:00PM to 9:00pm (Sunday, Monday, Tuesday)', 13, 10
               DB '   Appointment fee: 2000Tk', 13,10
               DB '   Advance amount required to confirm appointment: 50%', 13,10  
               DB 13,10, 'Doctor ID 2-',13,10
               DB '   Name: Dr. Bradley Smith',13,10
               DB '   Designation: Assistant Professor',13,10
               DB '   Available time: 6:00PM to 8:00pm (all weekdays)', 13, 10
               DB '   Appointment fee: 1500Tk', 13,10
               DB '   Advance amount required to confirm appointment: 30%', 13,10, '$'   

booking_details  DB 13,10,'Booking Details:======================================',13,10
                 DB 'To confirm your appointment, an advance payment is required.',13,10
                 DB 'Payment Options:',13,10
                 DB '   - Bank Transfer -> BRAC Bank, A/C No: 123456789',13,10
                 DB '   - bKash Payment ->01727573380 (Personal)',13,10
                 DB 'Please complete the advance payment to secure your booking.',13,10
                 DB 'Remaining balance can be paid at the hospital during visit.',13,10,'$'
                
 
doc1_id           dw 1
doc1_name         db "Dr. Sultana Rabeya$", 0
doc1_designation  db "Professor$", 0
doc1_fee          dw 2000
doc1_time         db "8:00PM-9:00PM$", 0
doc1_adv          dw 50

doc2_id           dw 2
doc2_name         db "Dr. Bradley Smith$", 0
doc2_designation  db "Assistant Professor$", 0
doc2_fee          dw 1500
doc2_time         db "7:00PM-8:00PM$", 0
doc2_adv          dw 30

choose_doctor      db 13,10, "Enter the doctor ID under which you want to make an appointment: $"
invalid_doctor     db 13,10, "Invalid doctor ID $" 
unavailable_doctor db 13,10, "Your chosen doctor currently has no available slot for appointment. Please try again later. $"
confirm            db 13,10, "========PRE-BOOKING CONFIRMATION(4)=========="
                   db 13,10, "Your pre-booking is confirmed under $"
send_money1        db 13,10, "Please make an online payment of $"
send_money2        db "TK to confirm your booking $"

;calculated variables
bmi dw 0  
lower_normal dw 0
higher_normal dw 0
payment dw 0  
chosen_doctor db 0

;admin  
adminoperation DB 13,10,'Press 1 to ADD slots in Doctor ID 1',13,10
               DB 'Press 2 to SUB slots in Doctor ID 1',13,10
               DB 'Press 3 to ADD slots in Doctor ID 2',13,10 
               DB 'Press 4 to SUB slots in Doctor ID 2',13,10
               DB 'Press any other key to Exit',13,10
               DB 'Enter a key: $',13,10  
invalid_slot db 13,10,"Slot count cannot be less than 0$"

.CODE
MAIN PROC

; initialize DS

MOV AX,@DATA
MOV DS,AX
 
; enter your code here 

start_system:
;############################-------LABIBA------------#########################################
; Show welcome
LEA DX, welcomeMsg
CALL printStr  
              

;FR1: TAKE INPUTS AND GENERATING USER'S DIGITAL HEALTH BOOK ====================================
CALL initial_system_input

;MENU BAR
CALL MENUBAR


   
   
;FR3: DIET SUGGESTION (CALC: BMR, CALORY ;AND SUGGESTION) ======================================

FR3:
CALL print_LineGap 
CALL print_LineGap
LEA DX, FR3_Msg
CALL printStr 
 


;BMR calculation
CALL BMR_calculator 

;calory calculation 
CALL calory_calculator
         

;DIET SUGGESTION PRINTING
CALL TDEE_calory_printing
CALL suggest_diet 

;MENU BAR
CALL MENUBAR            



;############################------NAHIAN----------############################


FR2: ;=========================================================================
;BMI
CALL BMI_calculation
CALL BMI_display 
CALL BMI_level
CALL appropriate_weight

;MENU BAR
CALL MENUBAR


appointment_feature:
;appointment  
CALL make_appointment

;MENU BAR
CALL MENUBAR


;admin
adminEnter:
  CMP adminflag, 1
  JE adminControl

adminControl: 
  CALL admin_function
                 

FR5:               
exit_system:
 
CALL print_LineGap
LEA DX,goodbyeMsg 
CALL printStr  

newuser:
CALL print_LineGap
LEA DX,start_newuser 
CALL printStr

MOV AH,1
INT 21H
SUB AL,48
CMP AL,1 

CALL print_LineGap
CALL print_LineGap
JE start_system 

JMP newuser


;exit to DOS
               
MOV AX,4C00H
INT 21H

MAIN ENDP


printStr PROC
    MOV AH, 09H
    INT 21H
    RET
printStr ENDP 

print_LineGap PROC
    MOV DL,10
    MOV AH,2
    INT 21H
    RET
print_LineGap ENDP



initial_system_input PROC
    
    CALL user_name_input
    
     
    ;ADMIN VERIFICATION =========================================================
     
    ;CHECKING NAME == ADMIN
    ;check_admin starts
    MOV SI,0
    MOV CX,5
    MOV BL, admin
    
    check_admin:
    
    CMP SI,0
    JG check_d
    
    check_a: 
    CMP user_name[SI],"a"
    JNE check_cap_A
    INC BL
    JMP next_iteration
    
    check_cap_A: 
    CMP user_name[SI],"A"
    JNE ask_next_inputs
    INC BL
    JMP next_iteration 
    
    check_d: 
    CMP SI,1
    JG check_m
    
    CMP user_name[SI],"d"
    JNE check_cap_D
    INC BL
    JMP next_iteration
    
    check_cap_D: 
    CMP user_name[SI],"D"
    JNE ask_next_inputs
    INC BL
    JMP next_iteration
    
    check_m: 
    CMP SI,2
    JG check_i
    
    CMP user_name[SI],"m"
    JNE check_cap_M
    INC BL
    JMP next_iteration
    
    check_cap_M: 
    CMP user_name[SI],"M"
    JNE ask_next_inputs
    INC BL
    JMP next_iteration
    
    check_i: 
    CMP SI,3
    JG check_n
    
    CMP user_name[SI],"i"
    JNE check_cap_I
    INC BL
    JMP next_iteration
    
    check_cap_I: 
    CMP user_name[SI],"I"
    JNE ask_next_inputs
    INC BL
    JMP next_iteration
    
    check_n:
    CMP SI,4
    JG next_iteration
    
    CMP user_name[SI],"n"
    JNE check_cap_N
    INC BL
    JMP next_iteration
    
    check_cap_N: 
    CMP user_name[SI],"N"
    JNE ask_next_inputs
    INC BL
    
    
    next_iteration:
    INC SI
    LOOP check_admin
    
    
    
    ; IF username == ADMIN, ADMIN=BL=5
    MOV admin, BL
    LEA DX, input_admin_pass
    CALL printStr
    
    
    ;TAKING ADMIN password INPUT  and
    ;CHECKING ADMIN password == "NaNdNm"
    MOV CX,6
    MOV SI,0
    MOV BL,admin_pass   
    
    input_verify_adm_pass:
    MOV AH,1
    INT 21H 
    CMP SI,0
    JG second_letter_check 
    CMP AL,"N"
    JNE break_adm_verify 
    JMP again_iterate
      
    second_letter_check:
    CMP SI,1
    JG third_letter_check 
    CMP AL,"a"
    JNE break_adm_verify 
    JMP again_iterate
                      
    third_letter_check:
    CMP SI,2
    JG fourth_letter_check 
    CMP AL,"N"
    JNE break_adm_verify 
    JMP again_iterate 
    
    fourth_letter_check:
    CMP SI,3
    JG fifth_letter_check 
    CMP AL,"d"
    JNE break_adm_verify 
    JMP again_iterate
    
    fifth_letter_check: 
    CMP SI,4
    JG last_letter_check 
    CMP AL,"N"
    JNE break_adm_verify 
    JMP again_iterate 
    
    last_letter_check:
    CMP AL,"m"
    JNE break_adm_verify 
    
    
    
    again_iterate:
    INC BL
    INC SI
    LOOP input_verify_adm_pass
    
    ; IF BL= admin_pass=6 (admin verified)
    MOV admin_pass,BL
    
    ;ADMIN logged in
    LEA DX, adloginMsg
    CALL printStr
    MOV adminflag,1
    JMP adminEnter
    
     
    break_adm_verify:
    LEA DX, ad_not_veri
    CALL printStr
    JMP exit_system 
    ;===============================================================================
    
    
    
    ;FOR USER=======================================================================
    ask_next_inputs:
    CALL take_user_inputs
    
    
    
    ;FR1: GENERATING USER'S DIGITAL HEALTH BOOK ====================================
    CALL generate_digital_health_book   
    
    RET
initial_system_input ENDP
    

one_digit_input PROC
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV AH,0
    ;AX= WHOLE 1 DIGIT VALUE 
    
    RET
one_digit_input ENDP


two_digit_input PROC
    MOV CX,0  
    
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV BL,10
    MUL BL
    ADD CX,AX
    
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV AH,0
    ADD CX,AX
    ;CX= WHOLE 2 DIGIT VALUE 
    
    RET
two_digit_input ENDP   

three_digit_input PROC
    MOV CX,0  
    
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV BL,100
    MUL BL
    ADD CX,AX 
    
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV BL,10
    MUL BL
    ADD CX,AX
    
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV AH,0
    ADD CX,AX
    ;CX= WHOLE 3 DIGIT VALUE 
    
    RET
three_digit_input ENDP

four_digit_output PROC
    MOV DX,0
    MOV AX,calory
    MOV CX,1000
    DIV CX
    MOV BX,DX
    
    ;PRINT 4
    MOV DL, AL
    ADD DL,48
    MOV AH,2
    INT 21H
    
    ;956/100= AX/100 =R:Q= AH:AL
    MOV AX,BX
    MOV CL,100
    DIV CL
    MOV BH,AH
    
    ;PRINT 9
    MOV DL, AL
    ADD DL,48
    MOV AH,2
    INT 21H
    
    ;56/10= AX/100 =R:Q= AH:AL
    MOV AL,BH
    MOV AH,0
    MOV CL,10
    DIV CL
    MOV BH,AH
    
    ;PRINT 5
    MOV DL, AL
    ADD DL,48
    MOV AH,2
    INT 21H
    
    ;PRINT 6
    MOV DL, BH
    ADD DL,48
    MOV AH,2
    INT 21H 
    
    CALL print_LineGap
    RET
four_digit_output ENDP


three_digit_output PROC
    
    ;1ST DIGIT
    MOV AH,0  ; AX= height
    MOV BL,100
    DIV BL
    
    MOV CH,AH ;R
    MOV CL,AL ;Q
    
    MOV DL,CL
    ADD DL,48
    MOV AH,2
    INT 21H 
    
    ;2ND DIGIT 
    MOV AH,0
    MOV AL,CH
    MOV BL,10
    DIV BL
    
    MOV BH,AH ;remainder
    MOV BL,AL ;quotient
    
    MOV DL,BL
    ADD DL,48
    MOV AH,2
    INT 21H  
    
    ;3RD DIGIT
    MOV DL,BH
    ADD DL,48
    MOV AH,2
    INT 21H
    RET 
three_digit_output ENDP
    
    
two_digit_output PROC
    MOV AH,0
    MOV BL,10
    DIV BL
    
    MOV BH,AH ;remainder
    MOV BL,AL ;quotient
    
    MOV DL,BL
    ADD DL,48
    MOV AH,2
    INT 21H  
    
    MOV DL,BH
    ADD DL,48
    MOV AH,2
    INT 21H
    RET
two_digit_output ENDP 

one_digit_output PROC
    ADD DL,48
    MOV AH,2
    INT 21H
    RET
one_digit_output ENDP 


user_name_input PROC
    ;TAKING username INPUT  and
    ;storing it into user_arr[0]
    LEA DX, input_name
    CALL printStr 
    
    MOV SI,0
    name_loop:
    MOV AH,1
    INT 21H 
    CMP AL,13
    JE ending_name
     
    MOV user_name[SI],AL
    INC SI
    JMP name_loop
    
    ending_name:
    INC SI 
    MOV user_name[SI],36
    
    RET
user_name_input ENDP    

take_user_inputs PROC 
    ask_gender:
    LEA DX, input_gender
    CALL printStr
    
    MOV AH,1
    INT 21H
    CMP AL,"F"
    JE store_gender
    CMP AL,"M"
    JNE invalid_gender
    
    store_gender:
    MOV gender,AL
    JMP ask_age
    
    invalid_gender:
    LEA DX, gender_invalid
    CALL printStr
    JMP ask_gender
    
    ask_age:
    LEA DX, input_age
    CALL printStr 
    CALL two_digit_input
    MOV age,CL
    
    
    
    LEA DX, input_weight
    CALL printStr 
    CALL two_digit_input
    MOV weight,CL
                 
    CALL ask_height_cm 
    
    LEA DX, input_actlvl
    CALL printStr 
    CALL one_digit_input
    MOV activity_level,AL
    
    RET 
take_user_inputs ENDP

generate_digital_health_book PROC
    CALL print_LineGap 
    CALL print_LineGap
    LEA DX, FR1_Msg
    CALL printStr 
    
    LEA DX, p_name
    CALL printStr
    LEA DX, user_name
    CALL printStr
    
    ;===========
    LEA DX, p_gender
    CALL printStr
    CMP gender,"F"
    JE female_print
    LEA DX, M_full
    
    female_print:
    LEA DX, F_full
    CALL printStr 
    
    ;===========
    LEA DX, p_age
    CALL printStr
    MOV AL,age 
    CALL two_digit_output 
    
    ;===========
    LEA DX, p_weight
    CALL printStr
    MOV AL,weight 
    CALL two_digit_output 
    
    ;===========
    LEA DX, p_height
    CALL printStr
    MOV AL,height 
    CALL three_digit_output
    
    ;===========
    LEA DX, p_actlvl
    CALL printStr 
    
    MOV BL,activity_level
    
    CMP BL,1
    JG check_2
    MOV SI,0
    JMP print_actlvl
    
    check_2:
    CMP BL,2
    JG check_3
    MOV SI,10
    JMP print_actlvl
    
    check_3:
    CMP BL,3
    JG check_4
    MOV SI,25
    JMP print_actlvl 
    
    check_4:
    MOV SI,43
    
    print_actlvl:
    LEA DX, activity_level_array[SI]
    CALL printStr
    
    CALL print_LineGap
    LEA DX, ending
    CALL printStr 
    
    RET
generate_digital_health_book ENDP




MENUBAR PROC
    LEA DX, input_menu
    CALL printStr
    
    MOV AH,1
    INT 21H
    SUB AL,48
    MOV menu,AL
    
    LEA DX, ending
    CALL printStr 
    
    ;MENU BAR
    CMP menu,2
    JE FR2
    CMP menu,3
    JE FR3
    CMP menu,4
    JE appointment_feature
    CMP menu,5
    JE exit_system
    
    RET 
MENUBAR ENDP 



ask_height_cm PROC
    LEA DX, input_height
    CALL printStr
     
    ;height input (three_digit_input)
    CALL three_digit_input
    MOV CH,0
    MOV height, CL
    RET
ask_height_cm ENDP 


                  
BMR_calculator PROC
    ;male  : BMR = 10*weight + 6.25*height - 5*age + 5
    ;female: BMR = 10*weight + 6.25*height - 5*age - 161
    
    ;scaled up by 1000 (to avoid floating point)
    ;male  : BMR = (10000*weight + 6250*height - 5000*age + 5000)   /1000
    ;female: BMR = (10000*weight + 6250*height - 5000*age - 161000) /1000
    
    
    ; DX:AX = 10000 * weight --- 
    MOV AL,weight
    MOV AH,0             ; AX = weight = 70
    MOV BX,10000
    MUL BX               ; DX:AX = 10000 * 70 = 700000  
    
    ; Store result in BX:CX
    MOV CX,AX            ; BX:CX will store 32-bit sum
    MOV BX,DX            ; BX:CX = DX:AX
    
    ; DX:AX = 6250 * height ---
    MOV AL,height        ; AX = height = 175
    MOV AH,0
    MOV DX,0             
    MOV SI,6250
    MUL SI               ; DX:AX = 6250 * 175 = 1093750
    
    ; Add DX:AX to BX:CX
    ADD CX,AX            ; add lower
    ADC BX,DX            ; add upper with carry (from CX+AX)
                                               
    ; DX:AX = 5000 * age ---
    MOV AL,age          
    MOV AH,0             ; AX = age
    MOV DX,0
    MOV SI,5000
    MUL SI               ; DX:AX = 5000 * 25 = 125000                                           
    
    ; Subtract DX:AX from BX:CX
    SUB CX,AX
    SBB BX,DX            ; sub upper with borrow (by CX-AX)
    ;==================================================================
    
    CMP gender,"M"
    JE bmr_m
    
    ; female bmr offset
    ; decimal 161000 
    ; hex     274E8
    ; H:L  =  2: 74E8  = 2 : 29928 (decimal)
    SUB CX,29928       ; lower 16 bits
    SBB BX, 2          ; upper 16 bits 
    JMP final_division
    
    bmr_m:
    ; male bmr offset
    ADD CX,5000         ; no upper bits, only add to lower part
    
    
    
    final_division:
    ;dividing 32-bit BX:CX by 1000
    
    MOV AX,CX           
    MOV DX,BX           
    MOV CX,1000
    DIV CX     ;DX:AX =R:Q          
    
              
    ;AX= the final result
    MOV BMR,AX
         
    RET
BMR_calculator ENDP   


calory_calculator PROC 
    MOV DX,0
    MOV AX, BMR
    
    CMP activity_level,1
    JG check_lvl2
    MOV BX,actlvl_1
    JMP next_step
    
    check_lvl2:
    CMP activity_level,2
    JG check_lvl3
    MOV BX,actlvl_2
    JMP next_step 
    
    check_lvl3:
    CMP activity_level,3
    JG check_lvl4
    MOV BX,actlvl_3
    JMP next_step 
    
    check_lvl4:
    MOV BX,actlvl_4
               
    next_step:
    ;BMR   * activity_factor = calory
    ;DX:AX * BX = DX: AX
    MUL BX 
    
    ; Divide by 1000 to scale down 
    ; DX:AX / CX = DX:AX = R:Q 
    MOV CX, 1000        
    DIV CX 
    
    MOV calory,AX
    
    RET                
calory_calculator ENDP
    
suggest_diet PROC
    CALL print_LineGap
    CALL BMI_calculation 
    CALL BMI_level
    MOV BL, BMIflag
    
    
    ;==PARAMETER 1: AGE ================================
    
    CMP age, 18
    JL TEEN
    CMP age, 36
    JL ADULT
    CMP age, 61
    JL SENIOR_ADULT
    JMP SENIOR    
    
    
     
    ;==PARAMETER 2: BMI STATUS ========================= 
    
    TEEN:                                                
    CMP BL,1      ; BL=BMI status = underweight = 1
    JG t_NOR_OVR_OBS
    JMP TEEN_UND
    
    
    t_NOR_OVR_OBS:
    CMP BL,2      ; BL=BMI status = normal = 2
    JG t_OVR_OBS
    JMP TEEN_NOR
    
    t_OVR_OBS:
    CMP BL,3      ; BL=BMI status = overweight = 3
    JG  TEEN_OBS  ; BL=BMI status = obese = 4
    JMP TEEN_OVR
    
  
    ;=============
    ADULT:
    CMP BL,1      ; BL=BMI status = underweight = 1
    JG a_NOR_OVR_OBS
    JMP ADULT_UND
    
    
    a_NOR_OVR_OBS:
    CMP BL,2      ; BL=BMI status = normal = 2
    JG a_OVR_OBS
    JMP ADULT_NOR
    
    a_OVR_OBS:
    CMP BL,3      ; BL=BMI status = overweight = 3
    JG  ADULT_OBS  ; BL=BMI status = obese = 4
    JMP ADULT_OVR 
        
        
    ;=============
    SENIOR_ADULT:
    CMP BL,1      ; BL=BMI status = underweight = 1
    JG sa_NOR_OVR_OBS
    JMP SNAD_UND
    
    
    sa_NOR_OVR_OBS:
    CMP BL,2      ; BL=BMI status = normal = 2
    JG sa_OVR_OBS
    JMP SNAD_NOR
    
    sa_OVR_OBS:
    CMP BL,3      ; BL=BMI status = overweight = 3
    JG  SNAD_OBS  ; BL=BMI status = obese = 4
    JMP SNAD_OVR
    
    ;=============
    SENIOR:
    CMP BL,1      ; BL=BMI status = underweight = 1
    JG s_NOR_OVR_OBS
    JMP SENR_UND
    
    
    s_NOR_OVR_OBS:
    CMP BL,2      ; BL=BMI status = normal = 2
    JG s_OVR_OBS
    JMP SENR_NOR
    
    s_OVR_OBS:
    CMP BL,3      ; BL=BMI status = overweight = 3
    JG  SENR_OBS  ; BL=BMI status = obese = 4
    JMP SENR_OVR
    
    
    ;==PARAMETER 3: GENDER ================================
    
    TEEN_UND:
    CMP gender, "F"
    JE fem_TEEN_UND 
    ;m_TEEN_UND
    LEA DX, M_TEEN_UND
    CALL printStr
    JMP EXIT
    
    ;================
    TEEN_NOR:
    CMP gender, "F"
    JE fem_TEEN_NOR 
    
    ;m_TEEN_NOR
    LEA DX, M_TEEN_NOR
    CALL printStr
    JMP EXIT
    
    ;=================
    TEEN_OVR:
    CMP gender, "F"
    JE fem_TEEN_OVR 
    
    ;m_TEEN_OVR
    LEA DX, M_TEEN_OVR
    CALL printStr
    JMP EXIT
    
    ;=================
    TEEN_OBS: 
    CMP gender, "F"
    JE fem_TEEN_OBS 
    
    ;m_TEEN_OBS
    LEA DX, M_TEEN_OBS
    CALL printStr
    JMP EXIT
    
    
    ;=================================
    ADULT_UND:
    CMP gender, "F"
    JE fem_ADLT_UND 
    
    ;m_ADLT_UNR
    LEA DX, M_ADLT_UND
    CALL printStr
    JMP EXIT 
    
    ;================
    ADULT_NOR:
    CMP gender, "F"
    JE fem_ADLT_NOR 
    
    ;m_ADLT_NOR
    LEA DX, M_ADLT_NOR
    CALL printStr
    JMP EXIT
    
    ;================
    ADULT_OVR:
    CMP gender, "F"
    JE fem_ADLT_OVR 
    
    ;m_ADLT_OVR
    LEA DX, M_ADLT_OVR
    CALL printStr
    JMP EXIT
    
    
    ;================
    ADULT_OBS:
    CMP gender, "F"
    JE fem_ADLT_OBS 
    
    ;m_ADLT_OBS
    LEA DX, M_ADLT_OBS
    CALL printStr
    JMP EXIT
    
    ;=================================
    SNAD_UND:
    CMP gender, "F"
    JE fem_SNAD_UND 
    
    ;m_SNAD_UND
    LEA DX, M_SNAD_UND
    CALL printStr
    JMP EXIT
    
    
    ;=================
    SNAD_NOR:
    CMP gender, "F"
    JE fem_SNAD_NOR 
    
    ;m_SNAD_NOR
    LEA DX, M_SNAD_NOR
    CALL printStr
    JMP EXIT
    
    ;=================
    SNAD_OVR:
    CMP gender, "F"
    JE fem_SNAD_OVR 
    
    ;m_SNAD_OVR
    LEA DX, M_SNAD_OVR
    CALL printStr
    JMP EXIT
    
    
    ;=================
    SNAD_OBS:
    CMP gender, "F"
    JE fem_SNAD_OBS 
    
    ;m_SNAD_OBS
    LEA DX, M_SNAD_OBS
    CALL printStr
    JMP EXIT
    
    
    ;=================================
    SENR_UND:
    CMP gender, "F"
    JE fem_SENR_UND 
    
    ;m_SENR_UND
    LEA DX, M_SENR_UND
    CALL printStr
    JMP EXIT
    
    ;=================
    SENR_NOR:
    CMP gender, "F"
    JE fem_SENR_NOR 
    
    ;m_SENR_NOR
    LEA DX, M_SENR_NOR
    CALL printStr
    JMP EXIT
    
    ;=================
    SENR_OVR: 
    CMP gender, "F"
    JE fem_SENR_OVR 
    
    ;m_SENR_OVR
    LEA DX, M_SENR_OVR
    CALL printStr
    JMP EXIT
    
    ;=================
    SENR_OBS: 
    CMP gender, "F"
    JE fem_SENR_OBS 
    
    ;m_SENR_OBS
    LEA DX, M_SENR_OBS
    CALL printStr
    JMP EXIT
    
    ;=====F_printing==================
    fem_TEEN_UND:
    LEA DX,F_TEEN_UND
    CALL printStr
    JMP EXIT
    
    fem_TEEN_NOR:
    LEA DX,F_TEEN_NOR
    CALL printStr
    JMP EXIT
    
    fem_TEEN_OVR:
    LEA DX,F_TEEN_OVR
    CALL printStr
    JMP EXIT
    
    fem_TEEN_OBS:
    LEA DX,F_TEEN_OBS
    CALL printStr
    JMP EXIT
    
    
    
    fem_ADLT_UND:
    LEA DX, F_ADLT_UND
    CALL printStr
    JMP EXIT
    
    fem_ADLT_NOR:
    LEA DX, F_ADLT_NOR
    CALL printStr
    JMP EXIT
    
    fem_ADLT_OVR:
    LEA DX, F_ADLT_OVR
    CALL printStr
    JMP EXIT
    
    fem_ADLT_OBS:
    LEA DX, F_ADLT_OBS
    CALL printStr
    JMP EXIT 
    
    
    fem_SNAD_UND:
    LEA DX, F_SNAD_UND
    CALL printStr
    JMP EXIT
    
    fem_SNAD_NOR:
    LEA DX, F_SNAD_NOR
    CALL printStr
    JMP EXIT
    
    fem_SNAD_OVR:
    LEA DX, F_SNAD_OVR
    CALL printStr
    JMP EXIT
    
    fem_SNAD_OBS:
    LEA DX, F_SNAD_OBS
    CALL printStr
    JMP EXIT 
    
    
    
    fem_SENR_UND:
    LEA DX, F_SENR_UND
    CALL printStr
    JMP EXIT
    
    fem_SENR_NOR:
    LEA DX, F_SENR_NOR
    CALL printStr
    JMP EXIT
    
    fem_SENR_OVR:
    LEA DX, F_SENR_OVR
    CALL printStr
    JMP EXIT
    
    fem_SENR_OBS:
    LEA DX, F_SENR_OBS
    CALL printStr
  
    EXIT:
    LEA DX, exit_diet
    CALL printStr
    MOV AH,1
    INT 21H
    CMP AL, "E"
    JNE EXIT
    
    CALL print_LineGap
    RET
    
suggest_diet ENDP  

TDEE_calory_printing PROC
    LEA DX, tdee
    CALL printStr
    CALL four_digit_output
    
    go_to_next_pg:
    CALL print_LineGap 
    LEA DX, next_pg
    CALL printStr
    MOV AH,1
    INT 21H
    SUB AL,48
    CMP AL,3
    JNE go_to_next_pg
    
    RET
TDEE_calory_printing ENDP


BMI_calculation PROC 
    MOV BL, height
    MOV AL, BL
    MUL BL ;AX=height^2 in cm^2
    MOV CX, AX ;CX = height^2
    
    
    MOV AL, weight
    MOV AH, 0 ;AX=weight
    MOV BX, 10000
    MUL BX  ;DX:AX=weight*10000(to convert cm^2 to m^2)->1m=100cm
    
    DIV CX ;DX:AX/CX->AX(quotient-BMI)
    MOV BMI, AX    
     
    RET
ENDP

BMI_display PROC
    LEA DX, BMI_msg
    MOV AH, 9
    INT 21H
    
    CALL print_BMI_value 
               
    LEA DX, kgm2
    MOV AH, 9
    INT 21H       
    RET 
ENDP

print_BMI_value PROC 
    MOV AX, BMI
    MOV BL, 10
    DIV BL    
    MOV DH, AH
    ;digit1
    ADD AL, 48
    MOV DL, AL
    MOV AH, 2
    INT 21H
    ;digit2
    MOV DL, DH
    ADD DL, 48
    MOV AH, 2
    INT 21H    
    RET
ENDP

BMI_level PROC
    CMP BMI, 19
    JLE level0
    CMP BMI, 25
    JLE level1
    CMP BMI, 30
    JLE level2
    ;else obese (level3)
    LEA DX, obese
    MOV AH, 9
    INT 21H 
    MOV BMIflag, 4
    RET
    
    level0:
    LEA DX, underweight
    MOV AH, 9
    INT 21H  
    MOV BMIflag, 1 
    RET
    
    level1:
    LEA DX, normal
    MOV AH, 9
    INT 21H   
    MOV BMIflag, 2
    RET
        
    level2:  
    LEA DX, overweight
    MOV AH, 9
    INT 21H   
    MOV BMIflag, 3
    RET
ENDP
    
appropriate_weight PROC
    ;BMI 19-25 is for normal weight 
    MOV AL, height
    MOV BL, height  
    MUL BL     ;height^2(in cm^2). result in AX 
    MOV CX, AX ;CX=height^2
    
    MOV AX, 19 
    MUL CX     ;lowerBMI*height^2 -> result is DX:AX
    
    MOV BX, 10000 ;1m^2=10000cm^2
    DIV BX        ;converting cm^2 to m^2 
    MOV lower_normal, AX
    
    MOV AX, 25
    MUL CX     ;higherBMI*height^2 -> result is DX:AX
    MOV BX, 10000 ;1m^2=10000cm^2
    DIV BX        ;converting cm^2 to m^2 
    MOV higher_normal, AX
    
    LEA DX, appropriate_weight_msg
    MOV AH, 9
    INT 21H
    
    MOV AX, lower_normal 
    print_appropriate_weight AX    
     
    ;print kg
    LEA DX, kg
    MOV AH, 9
    INT 21H
    
    ;print "and"
    LEA DX, a
    MOV AH, 9
    INT 21H
    
    MOV AX, higher_normal
    print_appropriate_weight AX
    
    ;print kg
    LEA DX, kg
    MOV AH, 9
    INT 21H  
    
    CALL print_LineGap
    RET
ENDP   

make_appointment PROC
    LEA DX, doctor_details
    MOV AH, 9
    INT 21H
    
    LEA DX, booking_details
    MOV AH, 9
    INT 21H
    
    LEA DX, choose_doctor
    MOV AH, 9
    INT 21H 
    
    MOV AH, 1
    INT 21H  
    SUB AL, 48 
    MOV chosen_doctor, AL
    
    CMP AL, 1
    JE doctor1
    
    CMP AL, 2
    JE doctor2
    
    ;invalid doctor ID
    LEA DX, invalid_doctor
    MOV AH, 9
    INT 21H
    RET
    
    doctor1:    
    appointment_counter
    
    MOV AX, doc1_fee 
    MOV BX, doc1_adv  
    calculate_advance AX, BX
    
    LEA DX, confirm
    MOV AH, 9
    INT 21H         
    
    LEA DX, doc1_name
    MOV AH, 9
    INT 21H
    
    JMP print_appointment_details 
    
    
    doctor2: 
    appointment_counter                       
    
    MOV AX, doc2_fee 
    MOV BX, doc2_adv 
    calculate_advance AX, BX  
    
    LEA DX, confirm
    MOV AH, 9
    INT 21H         
    
    LEA DX, doc2_name
    MOV AH, 9
    INT 21H
    
    JMP print_appointment_details
    
    
    print_appointment_details:        
    LEA DX, send_money1
    MOV AH, 9
    INT 21H
    
    MOV AX, payment  
    print_payment_amount AX      
    
    LEA DX, send_money2
    MOV AH, 9
    INT 21H        
    
    CALL print_LineGap
    RET
       
    no_available_slot: ;this is called from appointment_counter macro
    LEA DX, unavailable_doctor
    MOV AH, 9
    INT 21H  
    CALL print_LineGap
    RET
ENDP
    
admin_function PROC 
    adminLoop:
      LEA DX, adminoperation
      MOV AH, 9
      INT 21H
      
      MOV AH, 1 
      INT 21H
      CMP AL, '1'
      JE add_doc1_slot
      CMP AL, '2'
      JE sub_doc1_slot
      CMP AL, '3'
      JE add_doc2_slot
      CMP AL, '4'
      JE sub_doc2_slot
      RET
      
      add_doc1_slot:          
      MOV SI, 0
      MOV BL, doctor_level_array[SI]
      INC BL
      MOV doctor_level_array[SI], BL
      JMP adminLoop 
      
      sub_doc1_slot:          
      MOV SI, 0
      MOV BL, doctor_level_array[SI]
      DEC BL
      CMP BL, 0
      JL invalid_operation
      MOV doctor_level_array[SI], BL
      JMP adminLoop
      
      add_doc2_slot:          
      MOV SI, 1
      MOV BL, doctor_level_array[SI]
      INC BL
      MOV doctor_level_array[SI], BL
      JMP adminLoop
      
      sub_doc2_slot:          
      MOV SI, 1
      MOV BL, doctor_level_array[SI]
      DEC BL
      CMP BL, 0
      JL invalid_operation
      MOV doctor_level_array[SI], BL
      JMP adminLoop
      
      invalid_operation:
      LEA DX, invalid_slot
      MOV AH, 9
      INT 21H
      JMP adminLoop
ENDP  


    END MAIN





