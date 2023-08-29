#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY") # Svuota le tabelle e resetta gli indici degli elementi, per contare ripartendo da 1

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi

  if [[ $YEAR != "year" ]]
  then
    if [[ $ROUND != "round" ]]
    then
      if [[ $WINNER != "winner" ]]
      then
        if [[ $OPPONENT != "opponent" ]]
        then
          if [[ $WINNER_GOALS != "winner_goals" ]]
          then
            if [[ $OPPONENT_GOALS != "opponent_goals" ]]
            then
              WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
              OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
              INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
              if [[ $INSERT_RESULT == "INSERT 0 1" ]]
              then
                echo Inserted into games, $YEAR : $ROUND : $WINNER_ID : $OPPONENT_ID : $WINNER_GOALS : $OPPONENT_GOALS
              fi
            fi
          fi
        fi
      fi
    fi
  fi
done