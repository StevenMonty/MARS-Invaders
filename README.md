# MARS Invaders

![](https://github.com/StevenMonty/MIPS-Space-Invaders/blob/master/gamePlay.gif)

This particular assembly project spans multiple ```.asm``` files. Each game entity contains a ```controller``` file, a ```view``` file, and a ```model``` file. The main game driver itself runs in an infinite loop from the ```main.asm``` file.

### Game Modes
The game features three difficulty modes: Easy, Medium, and Hard. In the Easy game mode, the enemy sprites travel toward the player at a rate of 12 FPS. In Medium the enemies move 10 FPS, and in Hard mode, the enemies move at 8 FPS.

### Game Mechanics
The game features 5 enemy sprites that spawn from the upper bound of the screen. The enemies starting x position is randomly generated via the MIPS random int syscall, the enemies x position is then locked and they advance toward the player, along the y axis. The player ship moves along the x and y axis, in responce to the arrow keys on the keyboard. The B button is used to fire a bullet from the tip of the player ship. The bullet travels upward, locked in its x coordinate. Upon collision with an enemy ship, the ship and bullet both go inactive and an explosion animation flashes where the enemy was destroyed. If an enemy reaches the bottom the playable screen, the enemy is destroyed the players loses one of their remaining lives. If and enemy and the player collide at any point,


### Execution
In order to begin running the MARS IDE and emulator, run the following command
from the directory containing the Mars.jar file.

```
java -jar Mars.jar
```

Once the Mars IDE has loaded, open the ```main.asm``` file. You will have to assemble and run this in order to begin the game. Before attempting to assemble the game, first make sure that the 'Assemble all files in directory' option is checked by going to Settings > Assemble all files in directory.

Once the files have been successfully assembled, you are ready to play the game. Click the green 'Play' button to start the game. In order to display the game screen, you will have to go to Tools > Keypad and LED Display Simulator. Once the LED Display window has opened, you will have to click 'Connect to MIPS'. Once you've done that, you are ready to play.

### Note About Mars Version Used
MARS is the MIPS processor simulator and IDE. The version used for this project
was modified by [Jarrett Billingsley](https://github.com/jarrettbillingsley) for use in CS 447 - Computer Organization
and Assembly Language at the University of Pittsburgh. The MARS .jar file is
included in this repository, all credits go to Jarrett.

>Steven Montalbano © 2019
>University of Pittsburgh
