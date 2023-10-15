class SoundCloud {
  /**
   * @description takes a song's decibels value and tries to normalize it
   * This is somewhat of an approximation, and isn't the exact
   * equation, and based on a potentially off decibel reader:
   * https://www.checkhearing.org/soundmeter.php
   * @param {number} songDecibel - the song's decibel.
   * @param {number} lowestDecibel - the lowest decibel value found among the songs.
   * @returns {number} The volume to set the soundcloud player to.
  */
  static normalizeVolume(songDecibel, lowestDecibel){
    const maxVolume = (3**((lowestDecibel-songDecibel)/10)) * 100

    return maxVolume;
  }


  /**
   * @description Will gradually decrease the volume of the song and stop it.
   * @param {HTMLElement} widget - the soundcloud widget.
   * @param {number} normalizedVolume - the song's normalized volume.
   * @returns {null}
   */
  static decreaseVolumeAndStop(widget, normalizedVolume) {
      const targetVolume = 0;
      const duration = 2000; // 2 seconds
      const interval = 100; // Adjust interval for smoother effect
      const startingVolume = normalizedVolume;

      let currentVolume = startingVolume;
      const startTime = Date.now();

      // Recursively lowers the volume until the the music
      // has stopped.
      function loopLowerVolume() {
          const elapsedTime = Date.now() - startTime;

          if (elapsedTime < duration) {
              currentVolume = startingVolume - ((elapsedTime / duration) * 100);
              widget.setVolume(currentVolume);
              setTimeout(loopLowerVolume, interval);
          } else {
              // Ensure the final volume is set to the target
              widget.setVolume(targetVolume);
              widget.pause();
          }
      }


      loopLowerVolume();
  }


  /**
   * @description Will start the song and gradually increase the volume.
   * @param {HTMLElement} widget - the soundcloud widget.
   * @param {number} normalizedVolume - the song's normalized volume.
   * @returns {null}
  */
  static increaseVolume(widget, normalizedVolume) {
    const targetVolume = normalizedVolume;
    const duration = 2000; // 2 seconds
    const interval = 100; // Adjust interval for smoother effect

    let currentVolume = 0;
    const startTime = Date.now();

    // Will gradually increase the volume of the song.
    function loopIncreaseVolume() {
        const elapsedTime = Date.now() - startTime;

        if (elapsedTime < duration) {
            currentVolume = (elapsedTime / duration) * targetVolume;
            widget.setVolume(currentVolume);
            setTimeout(loopIncreaseVolume, interval);
        } else {
            // Ensure the final volume is set to the target
            widget.setVolume(targetVolume);
        }
    }
    
    loopIncreaseVolume();
  }

  /**
   * @description Will start the song and gradually increase the volume.
   * @param {number?} startTime - the soundcloud widget.
   * @param {number?} endTime - the song's normalized volume.
   * @returns { { startTimeInMicro: number, endTimeInMicro: (number | undefined) }}
  */
  static startAndEndTimesToMicroseconds(startTime, endTime) {
    let startTimeInMicro = 0;
    if(startTime) {
      const startMinuteValueInSeconds = parseInt(startTime.split(":")[0]) * 60;
      const startSecondsValue = parseInt(startTime.split(":")[1]);
      const start_total_seconds = startMinuteValueInSeconds + startSecondsValue;
      startTimeInMicro = start_total_seconds * 1000;
    } 

    let endTimeInMicro = undefined;
    if(endTime) {
      const endMinuteValueInSeconds = parseInt(endTime.split(":")[0]) * 60;
      const endSecondsValue = parseInt(endTime.split(":")[1]);
      const endTotalSeconds = endMinuteValueInSeconds + endSecondsValue;
      endTimeInMicro = endTotalSeconds * 1000;
    }
    
    return { startTimeInMicro, endTimeInMicro }
  }
}

