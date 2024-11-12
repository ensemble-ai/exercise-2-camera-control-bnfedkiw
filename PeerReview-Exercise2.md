# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* [Qixiang Fan] 
* *email:* [qxfan@ucdavis.edu]

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Position lock camera works as expected. The controller draw a 5 by 5 unit cross in the center of the screen.
___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The framing with horizontal auto-scroll camera works good. However, the player pushing forward by the box edge didn't shown,
since the player will move horizontally as same as auto-scroll camera.
These [lines](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/b4a3545f87860490d94bf64783de96d0ff92422a/Obscura/scripts/camera_controllers/framebound_autoscroller.gd#L25C1-L26C56) will set the player and the camera always move at the same velocity, so it can't test whether the player is pushed by the box edge.
After I comment these 2 lines the player is pushed by the box edge fine.
___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Position lock and lerp lock camera works good.
The camera follow the player that slower than player.
And when I stop moving the camera will catch up the player.
The distance between the player and camera also not excced the leash distance. When I speed up player, it will still keep a certain distance.
___
### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Lerp target focus camera works as expect.
The positon of camera lead the player in the direction of input as expect. It has a maximum distance between the player and camera. And when there are no movement input, the camera will be settled on the player after the cathup delay duration. 
___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
4-way sppedup push zone camera works good.
In the inner area, the camera will not moving.
The camera move at palyer moverment spped when player touch side of the border box. 
The camera will move at the speed of the ratio when the palyer between the speedup zone and push box border. However, the speed is set too slow, so no matter how the camera moves in this area, the
camera don't very obvious movement and hit the boarder box, only slight movement show that the player is in this speedup area.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
[variable type](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/position_lock.gd#L17) using : but not delcare the variable type of tpos.

[global variable](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/lerp_target.gd#L13)
Delcare variable in LerpTarget class but the variable only use in _process function. Put it in _process function would be better.

[global variable](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/position_lerp.gd#L10C1-L12C1)
Declare variable in positionLerp calls but only use in _process function. Set to local variable would be better.

#### Style Guide Exemplars ####

[clear local variable delcare](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/speedup_push.gd#L72C1-L79C61)
: clear variable names, easy to read and understand.

[clear code style on long if statement](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/lerp_target.gd#L52C3-L55C6)
: clear coding style increases readability when there are many conditions in if statement
___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

[auto scroll camera](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/b4a3545f87860490d94bf64783de96d0ff92422a/Obscura/scripts/camera_controllers/framebound_autoscroller.gd#L25C1-L26C56)
: these two lines set the player and the camera always both move in the same velocity, the palyer and camera will be position lock. So it hard to test whether the player is pushed by the box edge.

[speed setting in speedup zone](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/speedup_push.gd#L5C1-L9C67). 
: Since this camera is slight slow in spped-up, no matter how the camera moves in this area, the camera did't show an obvious movement.
change the speed ratio or change the space between pushbox and speedupzone to make the space larger would be slove the problem. 
So changing the initial exported variables will be fine.
___

#### Best Practices Exemplars ####
[exported variable](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/framebound_autoscroller.gd#L5)
: Well-placed exported variable and correct vector of top_left and bot_right for the boundaries to ensure the player stays within boundaries

[Deciding speed ratio](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/lerp_target.gd#L31C1-L35C2)
: Good implemented for choosing the speed to take a ratio off

[clear boundaries setting](https://github.com/ensemble-ai/exercise-2-camera-control-bnfedkiw/blob/bb65b749d40d90740de61096c7e497faa403856d/Obscura/scripts/camera_controllers/framebound_autoscroller.gd#L33C2-L47C56)
: clear implemented for the boundary of the player