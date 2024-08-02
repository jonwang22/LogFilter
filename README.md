This is a simple bash script exercise that helps us have a better understanding of utilizing while loops, for loops, if statements, and stdout redirection.

We have an authorization log file that we need to filter through and identify any suspicious activity that is happening. We're specifically looking for unauthorized access, failed password attempts, or errors in authentication.
What we don't want our script to pick up is any of the normal messages. 

At a high level, we're focusing on searching for the keywords Failed, Unauthorized, and Error. As we search we want to make our search case-insensitive so we can pick up any and all instances of these keywords within our log file.
After we've read through the file and identified the lines we need, we will have these lines redirected to our suspicious_activity.log file that will track daily suspicious activity.
Our script will also be ran daily. 

For more information and detail, please refer to the script comments.
