#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <strings.h>


int valid(char sudoku[9][9], char try, char pos_i, char pos_j) {
    char i;
    char j;

    for (i = 0; i < 9; i++) {
        if (sudoku[pos_i][i] == try)
            return 0;
        if (sudoku[i][pos_j] == try)
            return 0;
    }

    for (i = (pos_i/3)*3; i < (pos_i/3)*3 + 3; i++) {
        for (j = (pos_j/3)*3; j < (pos_j/3)*3 + 3; j++) {
            if (sudoku[i][j] == try)
                return 0;
        }
    }

    return 1;
}

void print_sudoku(char sudoku[9][9]) {
    char i;
    char j;

    for (i = 0; i < 9; i++) {
        for (j = 0; j < 9; j++) {
            printf("%c ", sudoku[i][j] + '0');
        }
        printf("\n");
    }
}


void solve(char sudoku[9][9], char pos_i, char pos_j) {
    if (pos_i == 9) {
        print_sudoku(sudoku);
        exit(0);
    }

    if (sudoku[pos_i][pos_j] != 0) {
        solve(sudoku, pos_i + (pos_j+1)/9, (pos_j + 1)%9);
        return ; 
    }


    char k;
    int vv;
    for (k = 1; k < 10; k++) {
        vv = valid(sudoku, k, pos_i, pos_j);
        /* printf("valid on %d on pos: (%d, %d) is %d\n", k, pos_i, pos_j, vv); */
        if (vv) {
            sudoku[pos_i][pos_j] = k;
            solve(sudoku, pos_i + (pos_j+1)/9, (pos_j + 1)%9);
        }
    }
    sudoku[pos_i][pos_j] = 0;
}


int main() {
    char sudoku[9][9];
    bzero(sudoku, sizeof(sudoku));

    /* sudoku[0][0] = 3; */
    /* sudoku[0][1] = 8; */
    /* sudoku[0][3] = 1; */
    /* sudoku[0][7] = 7; */
    /* sudoku[1][5] = 4; */
    /* sudoku[1][6] = 2; */
    /* sudoku[2][2] = 6; */
    /* sudoku[3][0] = 7; */
    /* sudoku[3][1] = 5; */
    /* sudoku[3][3] = 3; */
    /* sudoku[3][7] = 8; */
    /* sudoku[4][0] = 9; */
    /* sudoku[5][4] = 1; */
    /* sudoku[5][8] = 3; */
    /* sudoku[6][0] = 5; */
    /* sudoku[6][1] = 6; */
    /* sudoku[6][4] = 2; */
    /* sudoku[6][6] = 7; */
    /* sudoku[7][2] = 9; */
    /* sudoku[7][3] = 5; */
    /* sudoku[8][2] = 1; */
    /* sudoku[8][7] = 6; */


    solve(sudoku, 0, 0);

    return 0;
}
