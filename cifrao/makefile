all:
	flex cifrao.l
	bison -d cifrao.y
	gcc cifrao.tab.c lex.yy.c -o cifrao_parser