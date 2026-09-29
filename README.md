# Health Manager — 8086 Assembly

**Health Manager** is a menu-driven health management system built using **8086 Assembly Language**. It provides basic health calculations, diet suggestions and doctor appointment management through a DOS-style console interface.

## Features

* **Digital Health Book** — Collects name, gender, age, weight, height and activity level.
* **BMI Analysis** — Calculates BMI, determines the BMI category and estimates an appropriate weight range.
* **BMR & Calorie Calculation** — Calculates BMR and daily calorie requirements based on activity level.
* **Diet Recommendation** — Provides suggestions based on age, gender and BMI category.
* **Doctor Appointment Booking** — Displays doctors, checks availability, books slots and calculates advance payment.
* **Admin Management** — Allows administrators to add or remove appointment slots.

## System Flow

```text
                         START
                           |
                           v
                  Digital Health Book
                           |
                           v
                       Main Menu
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
         BMI              Diet         Appointment
       Analysis       Recommendation      Booking
          |                |                |
          v                v                v
   Appropriate Weight   Age/BMI/Gender   Availability
                                             |
                                             v
                                           Payment
                                             |
                                             v
                                      Admin Controls
```

## Technical Implementation

The project demonstrates the following 8086 Assembly concepts:

* **Procedures** for separating different parts of the program
* **Macros** for repeated operations
* **Arrays** for appointment availability
* **Conditional branching** for BMI classification, diet recommendations and appointment checks
* **Arithmetic operations** for BMI, BMR, calorie and payment calculations
* **DOS interrupts** for console input and output

### Main Procedures

```text
BMI_calculation
BMI_display
BMI_level
appropriate_weight
BMR_calculator
calory_calculator
TDEE_calory_printing
suggest_diet
make_appointment
admin_function
```

## Project Structure

```text
health-manager-assembly/
│
├── README.md
├── src/
│   └── health_manager.asm
└── screenshots/
    ├── welcome.png
    ├── health-book.png
    ├── bmi.png
    ├── diet.png
    ├── appointment.png
    └── admin.png
```

## How to Run

This project requires an **8086 Assembly development or emulation environment** such as EMU8086.

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/health-manager-assembly.git
```

### 2. Open the Source File

```text
src/health_manager.asm
```

Open the file in the 8086 Assembly environment used for development.

### 3. Assemble and Run

Assemble and execute the program using the compatible 8086 Assembly environment.

## Screenshots

Add screenshots of the main sections here:

* Health Book
* BMI Analysis
* Diet Recommendation
* Doctor Appointment
* Admin Controls

## Learning Outcomes

This project provided practical experience with:

* 8086 Assembly programming
* Registers and memory addressing
* Procedures and macros
* Conditional branching
* Arrays
* Arithmetic operations
* DOS interrupt-based input and output

## Future Improvements

* Persistent storage for health information
* More detailed diet recommendations
* Additional doctors and appointment schedules
* Improved input validation
* A more extensive health record system

## Author

**Nahian Raidah**
Computer Science & Engineering

## Project Type

Academic / Educational Project

> **Disclaimer:** This project is an educational demonstration of 8086 Assembly programming. The health calculations and recommendations are simplified and should not be treated as professional medical advice.
