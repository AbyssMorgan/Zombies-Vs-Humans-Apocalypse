#define RECORDING "owen" //This is the filename of your recording without the extension.

#define RECORDING_TYPE 1 //1 for in vehicle and 2 for on foot.

#include <a_npc>

main(){}

public OnRecordingPlaybackEnd() StartRecordingPlayback(RECORDING_TYPE, RECORDING);
#if RECORDING_TYPE == 1
  public OnNPCEnterVehicle(vehicleid, seatid) StartRecordingPlayback(RECORDING_TYPE, RECORDING);
  public OnNPCExitVehicle() StopRecordingPlayback();
#else
  public OnNPCSpawn() StartRecordingPlayback(RECORDING_TYPE, RECORDING);
#endif
