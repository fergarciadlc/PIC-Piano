# PIC-Piano
This project is a simple piano based on the diatonic scale using the PIC18F4550.

Schematic:
![Schematics](https://i.ibb.co/q503wxX/asm.png)
The frequencies were calculated based on the equal temperament scale, with A440 reference. Each semi-tone step is calculated using: $2^{1/12}$

$$ 
f(\text{G\# / Ab}) = 440 \times 2^{-1/12} = 415.30 \text{ Hz} \\ 
f(\text{A}_{440}) = 440 \times 2^{0/12} = 440.00 \text{ Hz}\\
f(\text{A\# / Bb}) = 440 \times 2^{1/12} = 466.16 \text{ Hz} 
$$

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

