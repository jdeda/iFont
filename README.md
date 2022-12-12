# 📖 iFont

<img src="https://user-images.githubusercontent.com/76166399/184219090-19e8f70d-8653-4b84-aacf-ead38b40e100.png" alt="drawing" width="650"/>

## Welcome to iFont!
iFont is a Font Manager for macOS built via the SwiftUI framework. It simply allows a user to manage and visualize fonts. The app is heavily predicated upon FontBook, a Font Manager program preinstalled on macOS.


## Scroll & Select
Scroll through font families with ease. Expand to see their individual fonts, Select families and fonts to visualize their text and meta data.

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_01.gif" alt="drawing" width="650"/>

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_02.gif" alt="drawing" width="650"/>

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_03.gif" alt="drawing" width="650"/>

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_04.gif" alt="drawing" width="650"/>

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_05.gif" alt="drawing" width="650"/>


### Build New Collections
Drag and drop a font family or font to add to your own collections.

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_06.gif" alt="drawing" width="650"/>

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_07.gif" alt="drawing" width="650"/>

# Load Fonts
Create a new library by opening up Finder to open a folder containing fonts. 

<img src="https://github.com/jdeda/iFont/blob/main/imgs/mov_08.gif" alt="drawing" width="650"/>

<br>

## Architecture & Design

## SwiftUI
All views were built using SwiftUI.

## TCA: State Managment

**Easy Composition of Views**
Using PointFree's [TCA State Management](https://github.com/pointfreeco/swift-composable-architecture) provided the ability to easily manage composition and communication of views, enabling easy to understand propagation of effects from one node in the feature tree, to another, or perhaps, several other nodes in the tree.

**Handling Advanced Side Effects & Streaming Data**
Apple's Combine library was instrumental in creating streams that read font files in the file system and emit Font objects. TCA's library incorporates Combine to model side effects and asynchronous work, and combining the two allowed very powerful features in the app. TCA allowed the ability to fire off these streams and cancel them in the event in-flight in the evnt they need to be interrupted due to other side effect (i.e. loading in a library, if we delete it while its loading data, cancel the stream).


## Bugs
- List selection lag
- List selection malfunction 
- List deletion malfunction
