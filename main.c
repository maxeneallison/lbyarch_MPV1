#include <stdio.h>
#include <stdint.h>

/*
- img1 is the source colored image data
- img2 is the destination grayscale image
- m is the width of the image in pixels
- n is the height of the image in pixels
*/

extern void cvtRGBToGray(uint8_t* img2, uint8_t* img1, int m, int n);

int main() {
    uint8_t rgb_img[] = {
        1, 2, 3,  4, 5, 6,  7, 8, 9,
        1, 2, 6,  2, 6, 7,  9, 4, 8,
        1, 5, 7,  1, 3, 3,  3, 4, 6
    };
    uint8_t gray_img[9];
    int width = 3;
    int height = 3;
    int i;

    cvtRGBToGray(gray_img, rgb_img, width, height);

    printf("Grayscale image:\n");

    for (i = 0; i < 9; i++) {
        printf("%d ", gray_img[i]);
        if ((i + 1) % width == 0)
            printf("\n");
    }
    

    return 0;
}