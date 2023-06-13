standard_fields=$(cat assets/standard_fields) #declaring the fields I want it to look for 
wrapper_fields=$(cat assets/wrapper_fields)
exercise_fields=$(cat assets/exercise_fields)

for FILE in */* 

do
    if grep -q -P "([^\/]+)\/\1.md" <<< $FILE  #searching file name as string for module naming convention, not searching within file itself
    then
        if grep -q "module_type: standard" $FILE
            then 
                for FIELD in ${standard_fields[*]}
                    do 
                        if grep -m  1 -Rq "$FIELD" "$FILE" #is $FIELD found in $FILE? 
                            then : 
                            else issues+=$"$FILE does not have the $FIELD field.\n"
                        fi
                    done
            else 
                if grep -q "module_type: exercise" $FILE
                    then 
                        for FIELD in ${exercise_fields[*]}
                            do 
                                if grep -m  1 -Rq "$FIELD" "$FILE" #is $FIELD found in $FILE? 
                                    then : 
                                    else issues+=$"$FILE does not have the $FIELD field.\n"
                                fi
                            done
                    else
                        if grep -q "module_type: wrapper" $FILE
                            then 
                                for FIELD in ${wrapper_fields[*]}
                                    do 
                                        if grep -m  1 -Rq "$FIELD" "$FILE" #is $FIELD found in $FILE? 
                                            then : 
                                            else issues+=$"$FILE does not have the $FIELD field.\n"
                                        fi
                                    done
                            else 
                            issues+="Either $FILE does not have a specified module type, or there is something wrong with the specified module_type. \n"
                        fi
                
                fi
        fi
    fi
done

# for end user clarity on what needs to be fixed
if [[ -z $issues ]] # is the length of $issues zero? 
    then echo "All checks passed: there were no issues identified with the YAML front matter."
    true
        else echo -e $issues
        false 
fi