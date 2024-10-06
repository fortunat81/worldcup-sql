#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE teams RESTART IDENTITY CASCADE"
cat games.csv | while IFS=',' read YEAR ROUND TEAM1 TEAM2 GOALS1 GOALS2
do
TEAM=$($PSQL "SELECT name FROM teams WHERE name='$TEAM1'")
echo $TEAM
if [ "$TEAM1" != 'winner' ]
then
if [ -z "$TEAM" ]
then
$PSQL "INSERT INTO teams (name) VALUES ('$TEAM1')"
fi
TEAM=$($PSQL "SELECT name FROM teams WHERE name='$TEAM2'")
echo $TEAM
if [ -z "$TEAM" ]
then
$PSQL "INSERT INTO teams (name) VALUES ('$TEAM2')"
fi
WINID=
OPID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM2'")
$PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM1'"),$OPID,$GOALS1,$GOALS2)"
fi
done

