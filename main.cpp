#include <iostream>
using namespace std;

#define ROW 9
#define COL 9

void printBoard(int** board) {
	for (int i = 0; i < ROW; i++) {
		for (int j = 0; j < COL; j++) {
			cout << board[i][j] << "\t";
		}
		cout << endl;
	}
}

void solve(int** board, int** markRow, int** markCol, int*** markMatrix, int i, int j) {
	if (i < ROW && j < COL) {
		if (board[i][j] == 0) {
			for (int num = 1; num <= 9; num++) {
				if (markRow[i][num - 1] == 0 && markCol[j][num - 1] == 0 && markMatrix[i / 3][j / 3][num - 1] == 0) {
					board[i][j] = num;
					markRow[i][num - 1] = 1;
					markCol[j][num - 1] = 1;
					markMatrix[i / 3][j / 3][num - 1] = 1;
					solve(board, markRow, markCol, markMatrix, i, j + 1);
					board[i][j] = 0;
					markRow[i][num - 1] = 0;
					markCol[j][num - 1] = 0;
					markMatrix[i / 3][j / 3][num - 1] = 0;
				}
			}
		}
		else {
			solve(board, markRow, markCol, markMatrix, i, j + 1);
		}
	}
	else if (i < ROW && j >= COL) {
		solve(board, markRow, markCol, markMatrix, i + 1, 0);
	}
	else {
		cout << "-------------------" << endl;
		printBoard(board);
		return;
	}
}

int main() {
	int sudoku[ROW][COL] = {
		{8, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 3, 6, 0, 0, 0, 0, 0},
		{0, 7, 0, 0, 9, 0, 2, 0, 0},
		{0, 5, 0, 0, 0, 7, 0, 0, 0},
		{0, 0, 0, 0, 4, 5, 7, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 3, 0},
		{0, 0, 1, 0, 0, 0, 0, 6, 8},
		{0, 0, 8, 5, 0, 0, 0, 1, 0},
		{0, 9, 0, 0, 0, 0, 4, 0, 0}
	};

	int** board = NULL;
	board = (int**)malloc(ROW * sizeof(int*));
	for (int i = 0; i < ROW; i++)
	{
		board[i] = (int*)malloc(COL * sizeof(int));
	}
	for (int i = 0; i < ROW; i++) {
		for (int j = 0; j < COL; j++) {
			board[i][j] = sudoku[i][j];
		}
	}
	

	//printBoard(board);
	//Initial
	int** markRow = NULL;
	int** markCol = NULL;
	int*** markMatrix;

	markRow = (int**)malloc(ROW * sizeof(int*));
	for (int i = 0; i < ROW; i++) {
		markRow[i] = (int*)malloc(COL * sizeof(int));
	}

	markCol = (int**)malloc(ROW * sizeof(int*));
	for (int i = 0; i < ROW; i++) {
		markCol[i] = (int*)malloc(COL * sizeof(int));
	}

	markMatrix = (int***)malloc(ROW * sizeof(int**));
	for (int i = 0; i < ROW/3; i++) {
		markMatrix[i] = (int**)malloc(COL/3 * sizeof(int*));
		for (int j = 0; j < COL/3; j++) {
			markMatrix[i][j] = (int*)malloc(COL * sizeof(int));
		}
	}

	for (int i = 0; i < ROW; i++) {
		for (int j = 0; j < COL; j++) {
			for (int z = 0; z < 9; z++) {
				markRow[i][z] = 0;
				markCol[j][z] = 0;
				markMatrix[i / 3][j / 3][z] = 0;
			}
		}
	}
	for (int i = 0; i < ROW; i++) {
		for (int j = 0; j < COL; j++) {
			if (board[i][j] != 0) {
				int num = board[i][j];
				markRow[i][num - 1] = 1;
				markCol[j][num - 1] = 1;
				markMatrix[i / 3][j / 3][num - 1] = 1;
			}
		}
	}

	//cout << "----- BOARD -----" << endl;
	//printBoard(board);
	//cout << "----- MARKROW -----" << endl;
	//printBoard(markRow);
	//cout << "----- MARKCOL -----" << endl;
	//printBoard(markCol);

	solve(board, markRow, markCol, markMatrix, 0, 0);
	
	return 0;
}
