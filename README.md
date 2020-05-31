# PIC-Piano
This project is a simple piano based on the diatonic scale using the PIC18F4550.

Schematic:
![Schematics](https://i.ibb.co/q503wxX/asm.png)
The frequencies were calculated based on the equal temperament scale, with A440 reference. Each semi-tone step is calculated using the <img src="https://render.githubusercontent.com/render/math?math=2^{1/12}"> factor.

<img src="https://render.githubusercontent.com/render/math?math=f(%5Ctext%7BG%5C%23%20%2F%20Ab%7D)%20%3D%20440%20%5Ctimes%202%5E%7B-1%2F12%7D%20%3D%20415.30%20%5Ctext%7B%20Hz%7D%20">

<img src="https://render.githubusercontent.com/render/math?math=f(%5Ctext%7BA%7D_%7B440%7D)%20%3D%20440%20%5Ctimes%202%5E%7B0%2F12%7D%20%3D%20440.00%20%5Ctext%7B%20Hz%7D">

<img src="https://render.githubusercontent.com/render/math?math=f(%5Ctext%7BA%5C%23%20%2F%20Bb%7D)%20%3D%20440%20%5Ctimes%202%5E%7B1%2F12%7D%20%3D%20466.16%20%5Ctext%7B%20Hz%7D">

Resulting in the following frequencies notes:
|Note| Frequency (Hz) |
|--|--|
|C|261|
|D|293|
|E|239|
|F|349|
|G|392|
|A|440|
|B|493|
|C|523|

The signal was generated using the PIC's timer 0  withe the PRESCALER.

