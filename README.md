# README

- The algorithms are developed based on the sum-of-squares module in **YALMP** and the semi-definite programming solver **MOSEK**. ***You need to include these tools in the root path of your Matlab before***.

- This repositories contains the codes to synthesis Reset Controllers for Hybrid System with respect to both **safety** and **liveness** properties.
- The main synthesis code is based on a reach-avoid algorithm in ***reach_aboidnoobstacle( )***
- The experiment of synthesising safety controller for hybrid automata is included in the **Safety** folder, and two experiments of synthesising liveness controller is in the **Liveness** folder.
- The objective functions of each experiment are calculted before using **Calculat_Obj( )**.

